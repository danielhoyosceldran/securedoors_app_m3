import 'package:flutter/material.dart';

void errorMessage(BuildContext context, String message)  {
  _baseMessage(context, message);
}

void infoMessage(BuildContext context, String message) {
  _baseMessage(context, message);
}

void _baseMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 12),
        ),
        duration: const Duration(seconds: 2)),
  );
}