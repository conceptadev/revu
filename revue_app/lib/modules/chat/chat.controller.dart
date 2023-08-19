import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

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
    this.repository,
    this.codeContext,
  }) {
    _buildContext();
  }

  final GithubRepositoryDto? repository;
  final String? codeContext;

  void _buildContext([String? preDefinedPrompt]) {
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

    // STEP Get the context to work with
    String getCodeContents() {
      if (codeContext != null) {
        // here it will get code context
        return codeContext!;
      } else {
        // STEP this is to get from github repository files
        if (repository != null) {
          return repository!.files
              .map((file) =>
                  '# file: ${file.path} \n ${decodeContent(file.content)}')
              .join('\n\n');
        }
      }

      return '';
    }

    // STEP first thing is to get the context to be used
    final contents = getCodeContents();

    // TODO: Change promp based on profile selected
    // need to create selection of profile
    final prompt =
        '''Act as a proficient software engineer and code reviewer with expertise
         in software development best practices. A codebase will be provided as 
         CONTEXT for your review. Thoroughly analyze the codebase to offer 
         knowledgeable insights, recommendations, and improvements based on our discussion.
         If necessary, seek additional information about the code's intended use cases or
         any specific aspects that need clarification. 

         Let's define a key work that only user can use, this will be sent in the future prompts, where it will change how your response only for the next result, please to not take assumptions, and consider this key word has it should be
            if no keyword was found, continue to reply normally:
              - for '[WRITE_FILE]' the response should be only Code (This is important so i will write a file with this response).

        CONTEXT:
        $contents
        ''';

    // STEP add both to initial message to be used has initial context
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
            '''Understood. I will use the context as the whole code base. I will critique but be insightful and helpful. 
            What would like to know first?''',
        createdAt: DateTime.now(),
      ),
    ]);

    String lastPrompt = preDefinedPrompt.isNull
        ? 'Give a full overview of the code base. Including the stack being used.'
        : preDefinedPrompt.toString();
    // After initial context has been set to the list, send a msg to api
    // to get some result and display
    sendMessage(ChatMessage(
      role: MessageRole.user,
      content: lastPrompt,
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
  Future<String> _previousMessageContext() async {
    final lastMessages = <ChatMessage>[];
    // Buffer of the number of the total tokens to avoid issues with the estimator.
    const tokenBuffer = 500;

    var tokenCount = 0;

    // Gett all messages before the latest one, make sure does not get more than 100k
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
  Future<void> sendMessage(ChatMessage message, [instant = false]) async {
    // STEP Add msg to ths list in the chat
    _messageList.add(message);

    _waitingResponse.value = true;

    // STEP make sure to get previous context to send to claud api
    final previousContext = await _previousMessageContext();

    try {
      // send TO API
      final response = await ClaudeService.sendCodeReviewRequest(
        previousContext,
        instant,
      );

      var showButton = false;
      // if (_messageList.isNotEmpty) {
      //   var lastMessage = _messageList.last;
      //   if (lastMessage.content.contains('[WRITE_FILE]')) {
      //     showButton = true;
      //   }
      // }

      _messageList.add(ChatMessage(
        content: response,
        role: MessageRole.assistant,
        createdAt: DateTime.now(),
        showCreateFileButton: showButton,
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

  void refreshContext(String content) {
    clearMessages();
    _buildContext(content);
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
