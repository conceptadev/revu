import 'package:flutter/widgets.dart';

class ConditionalWidget extends StatelessWidget {
  const ConditionalWidget({
    Key? key,
    required this.condition,
    required this.child,
    Widget? fallback,
  })  : _fallback = fallback ?? const SizedBox.shrink(),
        super(key: key);

  final bool? condition;
  final Widget child;
  final Widget _fallback;

  @override
  Widget build(BuildContext context) {
    return condition == true ? child : _fallback;
  }
}
