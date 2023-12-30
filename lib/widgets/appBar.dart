import 'package:flutter/material.dart';

PreferredSizeWidget? customAppBar({id: String, context: BuildContext}) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    title: Text(id),
    actions: <Widget>[
      IconButton(icon: const Icon(Icons.home), onPressed: () {
        while(Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
      ),
      //TODO lock/unlock all
    ],
  );
}