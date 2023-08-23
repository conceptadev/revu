import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revue_app/components/atoms/typing_indicator.dart';
import 'package:revue_app/components/molecules/bubble/bubble.widget.dart';
import 'package:revue_app/helpers/listenable_builder.dart';
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
    final isInstant = useState(true);

    final waitingResponse = useListenable(_chatController.waitingResponse);

    List<PromptDto> promptList = [
      PromptDto('Quick Onboard', ''''
        Please do introduction to what project does and create table about with the file path and a detailed description about what it does.
        I would like your response to be presented as a well structured markdown document and in a table format.
        '''),
      PromptDto('Code Review', '''
        Please review the provided code snippet for adherence to code quality principles. 
        Evaluate aspects such as DRY, SOLID principles, simplicity (KISS), modularity, error handling, and appropriate use of 
        comments/documentation. Additionally, assess the code's testing approach, version control practices, and consideration for performance optimization. 
        Identify areas where improvements could be made to align with these code quality principles.
        I would like your response to be presented as a well structured markdown document.
      '''),
      PromptDto('Architecture', 'Kindly conduct a review of the given code architecture. Evaluate the design for adherence to architectural best practices, such as separation of concerns, scalability, maintainability, and extensibility. Assess the usage of design patterns, the organization of modules/components, and the clarity of communication between different layers. Identify any potential architectural bottlenecks or areas that might benefit from refactoring to achieve a more robust and efficient architectural structure'),
      PromptDto('Project Score', ''' 
      I would like for you to review the code, and provide an overall project overview, that can be used as context for prompts for an AI React code reviewer. I would like your response to be presented as a well structured markdown document. With the following secctions:
      - Project Overview
      - Component Structure
      - Performance Optimizations
      - Code Quality
      - Defects or Bugs
      - Code Readability & Style
      - Overview:
      -- A score for each category from 0 - 10. Acting as a Senior React developer, rate yourself from 0-10 for each category as if you had written this code.

      Important be very critical and provide a lot of details, the goal is to provide a lot of information that the Code Reviewer can make the best decision possible.
      '''),
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

      _chatController.sendMessageStream(
        userMessage,
        instant: isInstant.value,
      );

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
      // appBar: AppBar(
      //   title: const Text('Chat'),
      // ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: MultiListenableBuilder(
              listenables: [
                _chatController.waitingResponse,
                _chatController.messages,
              ],
              builder: (context, child) {
                final filteredMessages = _chatController.messages.reverse
                    .where((element) => element.hidden == false)
                    .toList();
                final messageReverse = filteredMessages;
                return ListView.builder(
                  controller: scrollController,
                  reverse: true,
                  itemCount: messageReverse.length,
                  itemBuilder: (context, index) {
                    final message = messageReverse[index];
                    return MessageBubble(
                      message.content,
                      isMe: message.role == MessageRole.user,
                      isTyping:
                          _chatController.waitingResponse.value && index == 0,
                    );
                  },
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
