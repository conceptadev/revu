import 'package:flutter/material.dart';
import 'package:revue_app/modules/chat/dto/prompt_dto.dart';
import 'package:revue_app/components/atoms/card_prompt.widget.dart';

class GroupedPromptWidget extends StatelessWidget {
  final List<PromptDto> promptList;
  final int groupSize;
  final ValueChanged<String> onPromptSelected;

  GroupedPromptWidget({
    required this.promptList,
    required this.groupSize,
    required this.onPromptSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < promptList.length; i += groupSize)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int j = i; j < i + groupSize && j < promptList.length; j++)
                CardPromptWidget(
                  title: promptList[j].title,
                  prompt: promptList[j].prompt,
                  onPromptSelected: onPromptSelected,
                ),
            ],
          ),
      ],
    );
  }
}
