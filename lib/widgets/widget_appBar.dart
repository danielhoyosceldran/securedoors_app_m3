import 'package:flutter/material.dart';


import 'package:securedoors_app/screen_users.dart';PreferredSizeWidget? customAppBar({id: String, context: BuildContext, profilePhoto: String}) {
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
      GestureDetector(
        onTap: () {
          print("object");
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (context) => ScreenUsers())
          );
        },
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 15),
          clipBehavior: Clip.hardEdge,
          width: 25,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(
            "",
          ),
        ),
      )
    ],
  );
}