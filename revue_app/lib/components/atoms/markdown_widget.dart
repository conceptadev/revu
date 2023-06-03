import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class MarkdownWidget extends StatefulWidget {
  final String data;
  final EdgeInsetsGeometry? padding;
  final bool selectable;
  final MarkdownConfig? config;

  const MarkdownWidget({
    Key? key,
    required this.data,
    this.padding,
    this.selectable = true,
    this.config,
  }) : super(key: key);

  @override
  _MarkdownWidgetState createState() => _MarkdownWidgetState();
}

class _MarkdownWidgetState extends State<MarkdownWidget> {
  late MarkdownGenerator markdownGenerator;
  final List<Widget> _widgets = [];

  @override
  void initState() {
    super.initState();
    updateState();
  }

  void updateState() {
    markdownGenerator = MarkdownGenerator(config: widget.config);
    final result = markdownGenerator.buildWidgets(widget.data);
    _widgets.addAll(result);
  }

  void clearState() {
    _widgets.clear();
  }

  @override
  void dispose() {
    clearState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildMarkdownWidget();

  Widget buildMarkdownWidget() {
    final markdownWidget = ListView.builder(
      itemBuilder: (ctx, index) => _widgets[index],
      itemCount: _widgets.length,
      padding: widget.padding,
    );
    return widget.selectable
        ? SelectionArea(child: markdownWidget)
        : markdownWidget;
  }

  @override
  void didUpdateWidget(MarkdownWidget oldWidget) {
    clearState();
    updateState();
    super.didUpdateWidget(widget);
  }
}
