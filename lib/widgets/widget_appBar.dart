import 'package:flutter/material.dart';
import 'package:securedoors_app/screen_users.dart';
import 'package:securedoors_app/utils/modifiers.dart' as modifier;
import 'package:securedoors_app/data/currentUser.dart' as user;

PreferredSizeWidget? customAppBar(
    {id = String,
    context = BuildContext,
    profilePhoto = "lib/assets/users/ana.jpg"}) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    title: Text(modifier.quitUnderScore(modifier.capitalize(id))),
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
          padding: const EdgeInsets.only(left: 5, right: 10, top: 2, bottom: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white.withOpacity(0.1)
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                clipBehavior: Clip.hardEdge,
                width: 25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey.shade200),
                child: Image.asset(
                  user.getCurrentUserPhoto(),
                ),
              ),
              Text(
                user.getCurrentUserName(),
                style: const TextStyle(
                  fontSize: 11,
                ),
              )
            ],
          ),
        ),
      )
    ],
  );
}
