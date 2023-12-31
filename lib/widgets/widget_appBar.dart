import 'package:flutter/material.dart';
import 'package:securedoors_app/screen_users.dart';

PreferredSizeWidget? customAppBar(
    {id = String, context = BuildContext, profilePhoto = "lib/assets/users/ana.jpg"}) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    title: Text(id),
    actions: <Widget>[
      IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            while (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }),
      GestureDetector(
        onTap: () {
          while (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
              builder: (context) => const ScreenUsers()));
        },
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 15),
          clipBehavior: Clip.hardEdge,
          width: 25,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.grey.shade200),
          child: Image.asset(
            profilePhoto,
          ),
        ),
      )
    ],
  );
}
