import 'package:flutter/material.dart';
import 'package:revue_app/components/atoms/copy_clipboard_button.widget.dart';
import 'package:revue_app/components/atoms/markdown_viewer.dart';
import 'package:revue_app/components/molecules/dialog/dialog.widget.dart';

// bool isMarkdown(String content) {
//   const String markdownPattern =
//       r'(!*\[(.*)\]\((.*)\)|#+\s|`{3}\s*(.*)\s*`{3}|[*_]{1}\w+[*_]{1}|\*{2}\w+\*{2}|_{2}\w+_{2}|\*\s*\w+|\d+\.\s*\w+|^```|^>|<!--)';
//   RegExp markdownRegExp = RegExp(markdownPattern);

//   // Check if the markdownRegExp pattern is found in content
//   return markdownRegExp.hasMatch(content);
// }

class MessageBubble extends StatefulWidget {
  final String message;
  final bool isMe;
  final bool isTyping;
  final bool showButton;

  const MessageBubble(
    this.message, {
    required this.isMe,
    this.isTyping = false,
    this.showButton = false,
    super.key,
  });

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _hover = false;

  Widget _buildCopyButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        child: CopyToClipboardButton(
          content: widget.message,
        ),
      ),
    );
  }

  void _handleInputSubmitted(String inputText) {
    // TODO: send back to extension
    print(inputText);
    // Add the inputText to your object or perform any desired action
    // For example, you could add the input to a list of messages
    // setState(() {
    //   // Assuming you have a list of messages, you can add the inputText to it
    //   myMessages.add(inputText);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _hover = true;
        });
      },
      onExit: (event) {
        setState(() {
          _hover = false;
        });
      },
      child: Row(
        children: [
          Flexible(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: widget.isMe ? Colors.black12 : Colors.black26,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 16),
                            child: Icon(
                              widget.isMe ? Icons.person : Icons.bolt,
                              size: 20,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 16,
                            top: 16,
                            bottom: 16,
                          ),
                          child: MarkdownViewer(
                            widget.message,
                          ),
                        ),
                      ),
                      if (widget.showButton)
                        ElevatedButton(
                          onPressed: () {
                            //TODO: Send Last Message to VSCode;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return InputDialog(
                                  onInputSubmitted: _handleInputSubmitted,
                                );
                              },
                            );
                          },
                          child: Text("Create File"),
                        ),
                    ],
                  ),
                ),
                if (_hover) _buildCopyButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
