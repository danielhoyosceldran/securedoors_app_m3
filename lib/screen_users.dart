import 'package:flutter/material.dart';

class ScreenUsers extends StatelessWidget {
  const ScreenUsers({Key? key}) : super(key: key);

  Widget _user({profilePhoto: String, name: String}) {
    return Row(
      children: [
        Container(
          child: (profilePhoto == "no") ? 
            const Icon(Icons.person)
          : Image(image: profilePhoto),
        ),
        Text(name)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _user(profilePhoto: "no", name: "Ana"),
          _user(profilePhoto: "no", name: "Manel"),
          _user(profilePhoto: "no", name: "Eulalia"),
          _user(profilePhoto: "no", name: "Bernat"),
          _user(profilePhoto: "no", name: "Unknown"),
        ],
      ),
    );
  }
}
