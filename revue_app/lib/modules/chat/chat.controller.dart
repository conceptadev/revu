import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:revue_app/helpers/list.notifier.dart';
import 'package:revue_app/modules/anthropic/claude.service.dart';
import 'package:revue_app/modules/chat/dto/assistant_message.dto.dart';
import 'package:revue_app/modules/chat/dto/chat_message.dto.dart';
import 'package:revue_app/modules/chat/dto/message.dto.dart';
import 'package:revue_app/modules/chat/dto/user_message.dto.dart';
import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';
import 'package:revue_app/modules/github/dto/github_repository.dto.dart';

class ChatController {
  ChatController({
    required this.repository,
  }) {
    _buildContext();
  }

  final GithubRepositoryDto repository;

  void _buildContext() {
    // Create a prompt for an expert React code reviewer
    final candidateName = repository.repository.owner?.login ?? 'Candidate';

    String decodeContent(String? content) {
      if (content == null) {
        return '';
      }
      // trim whitespaces from content
      String cleanBase64String = content.replaceAll(RegExp(r'\s+'), '');
      final decodedContent = base64.decode(cleanBase64String);

      return utf8.decode(decodedContent, allowMalformed: true);
    }

    for (var file in repository.files) {
      print(file.path);
      print(decodeContent(file.content));
    }
    // Get the code contents
    // Display the file path before the code content
    final codeContents = repository.files
        .map((file) => '# file: ${file.path} \n ${decodeContent(file.content)}')
        .join('\n\n');

    final prompt =
        '''Act as a helpful  code reviewer. You were provided the task to do a code review for Candidate that is applying for a senior developer position.
        You will be provided a CONTEXT that will have each file path and its content.
        I want you to provide detailed insights in order to properly run technical qualifications on a candidate.

        You can call this candidate: $candidateName.

        CONTEXT:
        $codeContents
        ''';

    print(prompt);

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

    sendMessage(ChatMessage(
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

  ListNotifier<ChatMessage> get displayMessages => ListNotifier(
        messages.reverse.where((element) => element.hidden == false).toList(),
      );

  ValueNotifier<bool> get waitingResponse => _waitingResponse;

  // Chat service

  // Get the last messages up to the token count of GPTModel.maxTokens
  String get _previousMessageContext {
    final lastMessages = <ChatMessage>[];
    // Buffer of the number of the total tokens to avoid issues with the estimator.
    const tokenBuffer = 500;

    var tokenCount = 0;

    for (var i = _messageList.length - 1; i >= 0; i--) {
      final message = _messageList[i];
      tokenCount += message.tokenCount;

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
  Future<void> sendMessage(ChatMessage message) async {
    _messageList.add(message);

    _waitingResponse.value = true;

    try {
      final response = await ClaudeService.sendCodeReviewRequest(
        _previousMessageContext,
      );

      _messageList.add(ChatMessage(
        content: response,
        role: MessageRole.assistant,
        createdAt: DateTime.now(),
      ));
    } catch (e) {
      rethrow;
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
