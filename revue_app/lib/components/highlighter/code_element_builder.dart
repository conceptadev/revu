import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:revue_app/components/highlighter/highlight_view.dart';
import 'package:revue_app/screens/chat.screen.dart';

class CodeElementBuilder extends MarkdownElementBuilder {
  CodeElementBuilder();

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }

    final mediaQuery =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);

    final windowWidth = mediaQuery.size.width;

    final platformBrightness = mediaQuery.platformBrightness;

    return SizedBox(
      width: windowWidth,
      child: Stack(
        children: [
          SizedBox(
            width: windowWidth,
            child: HighlightView(
              element.textContent,
              language: language,
              theme: platformBrightness == Brightness.light
                  ? atomOneLightTheme
                  : atomOneDarkTheme,
              padding: const EdgeInsets.all(8),
              textStyle: GoogleFonts.robotoMono(),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.copy),
              iconSize: 16,
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: element.textContent),
                );
                scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')));
              },
            ),
          ),
        ],
      ),
    );
  }
}
