import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revue_app/components/atoms/typing_indicator.dart';
import 'package:revue_app/components/molecules/bubble/bubble.widget.dart';
import 'package:revue_app/modules/chat/chat.controller.dart';
import 'package:revue_app/modules/chat/dto/chat_message.dto.dart';
import 'package:revue_app/modules/chat/dto/prompt_dto.dart';
import 'package:revue_app/modules/chat/enum/chat_roles.enum.dart';
import 'package:revue_app/modules/github/dto/github_repository.dto.dart';
import 'package:revue_app/components/molecules/prompts/group_prompts.widget.dart'; // Import the widget

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class ChatScreen extends HookWidget {
  ChatScreen({
    this.repository,
    this.codeContext,
    super.key,
  }) : _chatController = ChatController(
          repository: repository,
          codeContext: codeContext,
        );

  final GithubRepositoryDto? repository;
  final String? codeContext;

  late final ChatController _chatController;

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = useTextEditingController();
    final ScrollController scrollController = useScrollController();
    final isInstant = useState(false);

    final waitingResponse = useListenable(_chatController.waitingResponse);
    final messages = useListenable(_chatController.displayMessages);

    List<PromptDto> promptList = [
      PromptDto('Onboard Me on the Project', 'Please do a onboard on the project with a table about the files and a short description about what it does.'),
      PromptDto('Do a Code Review', '''Please review the provided code snippet for adherence to code quality principles. Evaluate aspects such as DRYness, SOLID principles, simplicity (KISS), modularity, error handling, and appropriate use of comments/documentation. Additionally, assess the code's testing approach, version control practices, and consideration for performance optimization. Identify areas where improvements could be made to align with these code quality principles.'''),
      PromptDto('Architecture', 'Kindly conduct a review of the given code architecture. Evaluate the design for adherence to architectural best practices, such as separation of concerns, scalability, maintainability, and extensibility. Assess the usage of design patterns, the organization of modules/components, and the clarity of communication between different layers. Identify any potential architectural bottlenecks or areas that might benefit from refactoring to achieve a more robust and efficient architectural structure'),
      PromptDto('Write documentation', ''' Please perform a thorough review of the provided codebase to identify functions that require additional comments. Focus on functions that involve complex logic, algorithms, or any non-obvious implementation. Evaluate the clarity and comprehensibility of the code, and suggest suitable places where comments can be added to explain the purpose, behavior, and any key considerations of those functions. Your input will help enhance the codebase's readability and aid future developers in understanding the code more effectively. '''),
      // Add more prompt objects as needed.
    ];


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

      _chatController.sendMessage(userMessage, isInstant.value);

      textController.clear();
    }

    void handlePromptSelected(String prompt) {
      // final message = ChatMessage(
      //   content: prompt,
      //   role: MessageRole.user, // Assuming you have a MessageRole enum.
      //   createdAt: DateTime.now(),
      // );
    
      _chatController.refreshContext(prompt);
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
          ));
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
      appBar: AppBar(
        title: const Text('Chat'),
      ),
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
                //var showApplyCodeButton = false;

                // if ((messages.length - 1) == index) {
                //   final lastMessage = messages[index - 1];
                //   if (lastMessage.content.isNotEmpty) {
                //     if (lastMessage.content.contains('[WRITE_FILE]')) {
                //       showApplyCodeButton = true;
                //     }
                //   }
                // }

                return MessageBubble(
                  message.content,
                  isMe: message.role == MessageRole.user,
                  isTyping: _chatController.waitingResponse.value && index == 0,
                  showButton: message.showCreateFileButton,
                );
              },
            ),
          ),
          GroupedPromptWidget(
            promptList: promptList,
            groupSize: 2, // Set your desired group size here
            onPromptSelected: handlePromptSelected,
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
                hintText: 'Type a message 2',
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
                prefixIcon: Tooltip(
                  message: isInstant.value
                      ? 'Instant mode (claude-instant-v1.1-100k)'
                      : 'Enhanced mode (claude-v1.3-100k)',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      icon: Icon(
                        isInstant.value ? Icons.bolt : Icons.settings_suggest,
                      ),
                      iconSize: 18,
                      onPressed: () {
                        isInstant.value = !isInstant.value;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
