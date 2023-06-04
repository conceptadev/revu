import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revue_app/components/atoms/typing_indicator.dart';
import 'package:revue_app/components/molecules/bubble/bubble.widget.dart';
import 'package:revue_app/modules/chat/chat.controller.dart';
import 'package:revue_app/modules/chat/dto/chat_message.dto.dart';
import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';
import 'package:revue_app/modules/github/dto/github_repository.dto.dart';

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class ChatScreen extends HookWidget {
  ChatScreen({
    required this.repository,
    super.key,
  }) : _chatController = ChatController(repository: repository);

  final GithubRepositoryDto repository;

  late final ChatController _chatController;

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = useTextEditingController();
    final ScrollController scrollController = useScrollController();

    final waitingResponse = useListenable(_chatController.waitingResponse);
    final messages = useListenable(_chatController.displayMessages);

    void handleSubmit() async {
      final message = textController.text;

      if (message.isEmpty) {
        return;
      }
      final userMessage = ChatMessage(
        content: message,
        role: MessageRole.user,
        createdAt: DateTime.now(),
      );

      _chatController.sendMessage(userMessage);

      textController.clear();
    }

    Widget buildSendButton({
      required bool isTyping,
    }) {
      if (isTyping) {
        return const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: TypingIndicator(isTyping: true),
            ),
          ],
        );
      }
      return Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: IconButton(
          icon: const Icon(Icons.send),
          iconSize: 18,
          onPressed: () {
            handleSubmit();
          },
        ),
      );
    }

    final focusNode = FocusNode(
      onKey: (
        FocusNode node,
        RawKeyEvent event,
      ) {
        // Ignore for key up events
        if (event is RawKeyUpEvent) {
          return KeyEventResult.ignored;
        }

        final isEnterKey = event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter;

        if (event.isShiftPressed && isEnterKey) {
          textController.value = TextEditingValue(
            text: '${textController.text}\n',
            selection: TextSelection.collapsed(
              offset: textController.text.length + 1,
            ),
          );
          return KeyEventResult.handled;
        }

        if (isEnterKey) {
          if (event is RawKeyDownEvent) {
            handleSubmit();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
    );

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Chat'),
      // ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageBubble(
                  message.content,
                  isMe: message.role == MessageRole.user,
                  isTyping: _chatController.waitingResponse.value && index == 0,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: textController,
              keyboardType: TextInputType.multiline,
              autocorrect: true,
              focusNode: focusNode,
              enabled: !waitingResponse.value,
              minLines: 1,
              maxLines: null,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Type a message',
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.4),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                suffixIcon: buildSendButton(
                  isTyping: waitingResponse.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
