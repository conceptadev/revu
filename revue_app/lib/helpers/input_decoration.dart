import 'package:flutter/material.dart';

InputDecoration customInputDecoration(
  BuildContext context, {
  required String labelText,
  required String hintText,
}) {
  final theme = Theme.of(context);
  return InputDecoration(
    hintText: hintText,
    labelText: labelText,
    filled: true,
    fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.4),
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: theme.primaryColor),
    ),
  );
}
