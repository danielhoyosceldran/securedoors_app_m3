import 'package:flutter/material.dart';
import 'package:securedoors_app/screen_partition.dart';
import 'package:securedoors_app/utils/credentials.dart';
import 'package:securedoors_app/data/currentUser.dart';

class ScreenUsers extends StatelessWidget {
  const ScreenUsers({Key? key}) : super(key: key);

  Widget _user(BuildContext context, {profilePhoto: String, name: String, credentials: String}) {
    return GestureDetector(
      onTap: () {
        updateCurrentUser(
          currentUserCredentials: credentials,
          currentUserName: name,
          currentUserPhoto: profilePhoto
        );
        _navigateDownPartition(context, "ROOT", profilePhoto);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.only(left: 50),
                padding: const EdgeInsets.only(right: 20, bottom: 20),
                child: (profilePhoto == "no")
                    ? const Icon(
                  Icons.person,
                  size: 80,
                )
                    : Container(
                  clipBehavior: Clip.hardEdge,
                  width: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    color: Colors.grey.shade200
                  ),
                  child: Image.asset(
                    profilePhoto,
                  ),
                )),
            Text(name),
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(right: 40),
              child: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // To add user add firstly on lib/utils/credentials.dart
          _user(profilePhoto: "lib/assets/users/Ana.jpg", name: "Ana", context, credentials: CREDENTIALS["Ana"]),
          _user(profilePhoto: "lib/assets/users/Manel.jpg", name: "Manel", context, credentials: CREDENTIALS["Manel"]),
          _user(profilePhoto: "lib/assets/users/Eulalia.jpg", name: "Eulalia", context, credentials: CREDENTIALS["Eulalia"]),
          _user(profilePhoto: "lib/assets/users/Bernat.jpg", name: "Bernat", context, credentials: CREDENTIALS["Bernat"]),
        ],
      ),
    ));
  }

  void _navigateDownPartition(BuildContext context, String childId, String profilePhoto) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute<void>(builder: (context) => ScreenPartition(id: childId, profilePhoto: profilePhoto,))
    );
  }
}
