import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:revue_app/components/atoms/typing_indicator.dart';
import 'package:revue_app/components/molecules/bubble/bubble.widget.dart';
import 'package:revue_app/helpers/listenable_builder.dart';
import 'package:revue_app/modules/chat/chat.controller.dart';
import 'package:revue_app/modules/chat/dto/chat_message.dto.dart';
import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class ChatScreen extends StatefulWidget {
  // Modified here
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  // Modified here
  final ChatController _chatController = ChatController(userId: 'user123');
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _handleSubmit() async {
    final message = _textController.text;
    if (message.isEmpty) {
      return;
    }
    final userMessage = ChatMessage(
      content: message,
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );

    _chatController.sendMessage(userMessage);

    _textController.clear();
  }

  Widget _buildSendButton({
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
          _handleSubmit();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          _textController.value = TextEditingValue(
            text: '${_textController.text}\n',
            selection: TextSelection.collapsed(
              offset: _textController.text.length + 1,
            ),
          );
          return KeyEventResult.handled;
        }

        if (isEnterKey) {
          if (event is RawKeyDownEvent) {
            _handleSubmit();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
    );

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: MultiListenableBuilder(
          listenables: [
            _chatController.messages,
            _chatController.isTyping,
          ],
          builder: (context, child) {
            final messages = _chatController.messages.reverse;

            return Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageBubble(
                        message.content,
                        isMe: message.role == MessageRole.user,
                        isTyping: _chatController.isTyping.value && index == 0,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    focusNode: focusNode,
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
                      suffixIcon: _buildSendButton(
                        isTyping: _chatController.isTyping.value,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
