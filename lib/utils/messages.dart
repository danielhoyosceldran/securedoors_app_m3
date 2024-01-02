import 'package:flutter/material.dart';

void errorMessage(BuildContext context, String message)  {
  _baseErrorMessage(context, message);
}

void infoMessage(BuildContext context, String message) {
  _baseInfoMessage(context, message);
}

void lockedMessage(BuildContext context) {
  _baseInfoMessage(context, "Locked!");
}

void unlockedMessage(BuildContext context) {
  _baseInfoMessage(context, "Unlocked!");
}

void closedMessage(BuildContext context) {
  _baseInfoMessage(context, "Closed!");
}

void openedMessage(BuildContext context) {
  _baseInfoMessage(context, "Opened!");
}

void credentialsError(BuildContext context) {
  _baseErrorMessage(context, "You don't have permission to do this action.");
}

void _baseInfoMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(
                  fontSize: 12,
                color: Colors.black
              ),
            ),
          ],
        ),
        backgroundColor: Colors.yellow.shade100,
        duration: const Duration(seconds: 2)),
  );
}


void _baseErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red.shade100,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2)),
  );
}