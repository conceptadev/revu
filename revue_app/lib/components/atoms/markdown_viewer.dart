import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/paraiso-dark.dart';
import 'package:flutter_highlight/themes/paraiso-light.dart';
import 'package:markdown_widget/markdown_widget.dart' as mdw;
import 'package:markdown_widget/widget/all.dart';

class MarkdownViewer extends StatelessWidget {
  const MarkdownViewer(
    this.data, {
    super.key,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final config = isDark
        ? mdw.MarkdownConfig.darkConfig
        : mdw.MarkdownConfig.defaultConfig;

    return mdw.MarkdownWidget(
      padding: const EdgeInsets.all(0),
      config: config.copy(
        configs: [
          PreConfig.darkConfig.copy(
            theme: isDark ? paraisoDarkTheme : paraisoLightTheme,
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          )
        ],
      ),
      shrinkWrap: true,
      data: data,
    );
  }
}
