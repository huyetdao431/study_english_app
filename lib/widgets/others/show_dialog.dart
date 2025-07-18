import 'package:flutter/material.dart';

void showMyDialog(BuildContext context, String title, String content, {VoidCallback? onClick}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onClick!();
          },
          child: Text("OK"),
        ),
      ],
    ),
  );
}
