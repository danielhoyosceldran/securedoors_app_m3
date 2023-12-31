import 'package:flutter/material.dart';

void errorMessage(BuildContext context, String message)  {
  _baseMessage(context, message);
}

void infoMessage(BuildContext context, String message) {
  _baseMessage(context, message);
}

void lockedMessage(BuildContext context) {
  _baseMessage(context, "Locked!");
}

void unlockedMessage(BuildContext context) {
  _baseMessage(context, "Unlocked!");
}

void closedMessage(BuildContext context) {
  _baseMessage(context, "Closed!");
}

void openedMessage(BuildContext context) {
  _baseMessage(context, "Opened!");
}

void credentialsError(BuildContext context) {
  _baseError(context, "You don't have permission to do this action.");
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
void _baseError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red.shade100,
        content: Text(
          message,
          style: const TextStyle(
              fontSize: 12,
            color: Colors.black
          ),
        ),
        duration: const Duration(seconds: 2)),
  );
}