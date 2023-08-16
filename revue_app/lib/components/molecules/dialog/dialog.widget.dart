import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget {
  final void Function(String) onInputSubmitted;

  const InputDialog({Key? key, required this.onInputSubmitted})
      : super(key: key);

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late String inputText;

  @override
  void initState() {
    super.initState();
    inputText = "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter a String"),
      content: TextField(
        onChanged: (value) {
          setState(() {
            inputText = value;
          });
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            widget.onInputSubmitted(inputText); // Pass input to parent widget
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
