import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:revue_app/helpers/list.notifier.dart';
import 'package:revue_app/modules/anthropic/claude.service.dart';
import 'package:revue_app/modules/chat/dto/assistant_message.dto.dart';
import 'package:revue_app/modules/chat/dto/chat_message.dto.dart';
import 'package:revue_app/modules/chat/dto/message.dto.dart';
import 'package:revue_app/modules/chat/dto/user_message.dto.dart';
import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';

class ChatController {
  ChatController({
    required String userId,
  });
  // List of messages
  final ListNotifier<ChatMessage> _messageList = ListNotifier<ChatMessage>();

  final ValueNotifier<bool> _waitingResponse = ValueNotifier<bool>(false);

  ListNotifier<ChatMessage> get messages => _messageList;

  ValueNotifier<bool> get isTyping => _waitingResponse;

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
