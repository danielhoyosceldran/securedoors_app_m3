import 'package:flutter/material.dart';
import 'package:securedoors_app/utils/tree.dart';
import 'package:securedoors_app/requests/actionsRequests.dart' as req;
import 'dart:async';
import 'package:securedoors_app/utils/messages.dart' as message;
import 'package:securedoors_app/utils/alerts.dart' as alert;
import 'package:securedoors_app/widgets/widget_appBar.dart';

class ScreenSpace extends StatefulWidget {
  final String id;
  String? profilePhoto;

  ScreenSpace(
      {Key? key,
      required this.id,
      this.profilePhoto = "lib/assets/users/guest.jpg"})
      : super(key: key);

  @override
  State<ScreenSpace> createState() => _ScreenSpaceState();
}

class _ScreenSpaceState extends State<ScreenSpace> {
  late Future<Tree> futureTree;

  late Timer _timer;
  static const int periodeRefresh = 2;

  // better a multiple of period in TimeTracker, 2 seconds

  void _activateTimer() {
    _timer = Timer.periodic(const Duration(seconds: periodeRefresh), (Timer t) {
      futureTree = req.getTree(widget.id);
      setState(() {});
    });
  }

  @override
  void dispose() {
    // "The framework calls this method when this State object will never build again"
    // therefore when going up
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureTree = req.getTree(widget.id);
    _activateTimer();
  }

// future with listview
// https://medium.com/nonstopio/flutter-future-builder-with-list-view-builder-d7212314e8c9
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tree>(
      future: futureTree,
      builder: (context, snapshot) {
        // anonymous function
        if (snapshot.hasData) {
          return Scaffold(
            appBar: customAppBar(
                context: context,
                id: snapshot.data!.root.id,
                profilePhoto: widget.profilePhoto),
            body: ListView.separated(
              // it's like ListView.builder() but better because it includes a separator between items
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.root.children.length,
              itemBuilder: (BuildContext context, int i) =>
                  _buildRow(snapshot.data!.root.children[i], i),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a progress indicator
        return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  Widget _buildRow(Door door, int index) {
    return ListTile(
      title: Text(door.id),
      leading: (door.state == "locked")
          ? const Icon(Icons.lock_outline)
          : (door.closed)
              ? const Icon(Icons.door_back_door_outlined)
              : const Icon(Icons.meeting_room_outlined),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextButton(
            onPressed: () {
              if (door.state == 'locked') {
                if (door.closed) message.infoMessage(context, "Unlocking...");
                req.unlockDoor(door).then(
                    (value) => {if (!value) message.credentialsError(context)});
              } else if (door.closed) {
                message.infoMessage(context, "Locking...");
                req.lockDoor(door).then(
                    (value) => {if (!value) message.credentialsError(context)});
              } else {
                message.errorMessage(
                    context, "Can't lock this door because it's opened.");
              }
              futureTree = req.getTree(widget.id);
              setState(() {});
            },
            child:
            Text(
              (door.state == "locked") ? "Unlock" : "Lock", // lockUnlockButton = "lock"
              style: TextStyle(
                  color: (door.closed)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey),
            ), // lockUnlockButton = "unlock"
            /*
            Icon(
                (door.state == "locked")
                    ? Icons.lock_open_outlined
                    : Icons.lock_outline,
                color: (door.closed)
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              )),
             */
          ),
          TextButton(
            onPressed: () {
              if (!door.closed) {
                if (door.state == 'unlocked') {
                  message.infoMessage(context, "Closing...");
                }
                req.closeDoor(door).then(
                    (value) => {if (!value) message.credentialsError(context)});
              } else if (door.state == 'unlocked') {
                message.infoMessage(context, "opening...");
                req.openDoor(door).then(
                    (value) => {if (!value) message.credentialsError(context)});
              } else {
                message.errorMessage(
                    context, "Can't open this door because it's locked.");
              }
              futureTree = req.getTree(widget.id);
              setState(() {});
            },
            child: Text(
              (door.closed) ? "Open" : "Close",
              style: TextStyle(
                  color: (door.state == 'unlocked')
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey),
            ),
            /*
            Icon(
                (door.closed) ? Icons.door_back_door_outlined : Icons.meeting_room_outlined,
                color: (door.state == "unlocked")
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              )),
             */
          ),
        ],
      ),
    );
  }
}
