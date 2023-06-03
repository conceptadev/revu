import 'dart:async';

import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final bool isTyping;

  const TypingIndicator({super.key, required this.isTyping});

  @override
  // ignore: library_private_types_in_public_api
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> {
  Timer? _timer;
  final List<double> _dotSizes = [6.0, 8.0, 10.0];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _stopTimer();
  }

  void _startTimer() {
    // Start a Timer to update the size and opacity of the dots in sequence
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotSizes.insert(0, _dotSizes.removeLast());
      });
    });
  }

  void _stopTimer() {
    // Stop the timer when the widget is disposed
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isTyping
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: _dotSizes[0],
                width: _dotSizes[0],
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(width: 4.0),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: _dotSizes[1],
                width: _dotSizes[1],
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(width: 4.0),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: _dotSizes[2],
                width: _dotSizes[2],
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[400],
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
