import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:revue_app/helpers/list.notifier.dart';
import 'package:revue_app/modules/anthropic/anthropic.service.dart';
import 'package:revue_app/modules/anthropic/dto/completion_response.dto.dart';
import 'package:revue_app/modules/anthropic/dto/sampling_params.dto.dart';
import 'package:revue_app/modules/chat/dto/assistant_message.dto.dart';
import 'package:revue_app/modules/chat/dto/chat_message.dto.dart';
import 'package:revue_app/modules/chat/dto/message.dto.dart';
import 'package:revue_app/modules/chat/dto/user_message.dto.dart';
import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';
import 'package:revue_app/modules/github/dto/github_repository.dto.dart';

class ChatController {
  final _client = AnthropicClient();
  ChatController({
    this.repository,
    this.codeContext,
  }) {
    _buildContext();
  }

  final GithubRepositoryDto? repository;
  final String? codeContext;

  void _buildContext() {
    // Create a prompt for an expert React code reviewer

    String decodeContent(String? content) {
      if (content == null) {
        return '';
      }
      // trim whitespaces from content
      String cleanBase64String = content.replaceAll(RegExp(r'\s+'), '');
      final decodedContent = base64.decode(cleanBase64String);

      return utf8.decode(decodedContent, allowMalformed: true);
    }

    String getCodeContents() {
      if (codeContext != null) {
        return codeContext!;
      } else {
        if (repository != null) {
          return repository!.files
              .map((file) =>
                  '# file: ${file.path} \n ${decodeContent(file.content)}')
              .join('\n\n');
        }
      }

      return '';
    }

    final contents = getCodeContents();

    final prompt =
        '''Act as a React Native, and typescript expert software engineer and code reviewer with expertise
         in software development best practices. A codebase will be provided as 
         CONTEXT for your review. Thoroughly analyze the codebase to offer 
         knowledgeable insights, recommendations, and improvements based on our discussion.
         If necessary, seek additional information about the code's intended use cases or
         any specific aspects that need clarification.

        CONTEXT:
        $contents
        ''';

    _messageList.addAll([
      ChatMessage(
        role: MessageRole.user,
        content: prompt,
        hidden: true,
        createdAt: DateTime.now(),
      ),
      ChatMessage(
        role: MessageRole.assistant,
        hidden: true,
        content:
            'Understood. I will use the context as the whole code base. I will critique but be insightful and helpful. What would like to know first?',
        createdAt: DateTime.now(),
      ),
    ]);

    sendMessageStream(ChatMessage(
      role: MessageRole.user,
      content:
          'Give a full overview of the code base. Including the stack being used.',
      hidden: true,
      createdAt: DateTime.now(),
    ));
  }

  // List of messages
  final ListNotifier<ChatMessage> _messageList = ListNotifier<ChatMessage>();

  final ValueNotifier<bool> _waitingResponse = ValueNotifier<bool>(false);

  ListNotifier<ChatMessage> get messages => _messageList;

  ValueNotifier<bool> get waitingResponse => _waitingResponse;

  // Chat service

  // Get the last messages up to the token count of GPTModel.maxTokens
  Future<String> _previousMessageContext() async {
    final lastMessages = <ChatMessage>[];
    // Buffer of the number of the total tokens to avoid issues with the estimator.
    const tokenBuffer = 500;

    var tokenCount = 0;

    for (var i = _messageList.length - 1; i >= 0; i--) {
      final message = _messageList[i];
      tokenCount += await message.getTokenCount();

      if (tokenCount >= 100000 - tokenBuffer) {
        break;
      }

      lastMessages.add(message);
    }

    MessageDto messageMapper(ChatMessage message) {
      if (message.role == MessageRole.assistant) {
        return AssistantMessageDto(
          content: message.content,
        );
      }

      if (message.role == MessageRole.user) {
        return UserMessageDto(
          content: message.content,
        );
      }

      throw Exception('Invalid message role');
    }

    final messages = lastMessages.reversed.map(messageMapper).toList();

    return formatMessages(
      messages
        ..add(
          AssistantMessageDto(content: ''),
        ),
    );
  }

  // Add message
  Future<void> sendMessage(
    ChatMessage message, {
    instant = false,
    CancellationToken? cancellationToken,
  }) async {
    _messageList.add(message);

    _waitingResponse.value = true;

    final previousContext = await _previousMessageContext();

    try {
      final response = await _client.complete(
        SamplingParametersDto(
          prompt: previousContext,
          model: instant
              ? AnthropicModel.claudeInstantV1_1_100k
              : AnthropicModel.claudeV1_3_100k,
        ),
      );

      _messageList.add(ChatMessage(
        content: response.completion,
        role: MessageRole.assistant,
        createdAt: DateTime.now(),
      ));
    } catch (e) {
      rethrow;
    } finally {
      _waitingResponse.value = false;
    }
  }

  Future<void> sendMessageStream(
    ChatMessage message, {
    instant = false,
    CancellationToken? cancellationToken,
  }) async {
    _messageList.add(message);

    _waitingResponse.value = true;

    final previousContext = await _previousMessageContext();

    _messageList.add(
      ChatMessage(
        content: '',
        role: MessageRole.assistant,
        createdAt: DateTime.now(),
      ),
    );

    void onUpdate(CompletionResponseDto response) {
      final lastIndex = _messageList.length - 1;
      final message = _messageList.last.copyWith(
        content: response.completion,
      );

      _messageList.update(lastIndex, message);
    }

    try {
      await _client.completeStream(
        SamplingParametersDto(
          prompt: previousContext,
          model: instant
              ? AnthropicModel.claudeInstantV1_1_100k
              : AnthropicModel.claudeV1_3_100k,
        ),
        onUpdate: onUpdate,
        cancellationToken: cancellationToken,
      );
    } catch (e) {
      print(e);
    } finally {
      _waitingResponse.value = false;
    }
  }

  // Clear messages
  void clearMessages() {
    _messageList.clear();
  }
}

String formatMessages<T extends MessageDto>(List<MessageDto> messages) {
  final StringBuffer formattedMessages = StringBuffer();

  for (final message in messages) {
    if (message.role == MessageRole.assistant) {
      formattedMessages.writeln("Assistant:");
    } else if (message.role == MessageRole.user) {
      formattedMessages.writeln("Human:");
    }
    formattedMessages.writeln(message.content);
    formattedMessages.writeln('');
  }

  return formattedMessages.toString();
}
