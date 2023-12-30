import 'package:flutter/material.dart';
import 'package:securedoors_app/tree.dart';
import 'package:securedoors_app/requests/actionsRequests.dart' as req;
import 'dart:async';
import 'package:securedoors_app/utils/messages.dart' as message;

class ScreenSpace extends StatefulWidget {
  final String id;

  const ScreenSpace({Key? key, required this.id}) : super(key: key);

  @override
  State<ScreenSpace> createState() => _ScreenSpaceState();
}

class _ScreenSpaceState extends State<ScreenSpace> {
  late Future<Tree> futureTree;

  late Timer _timer;
  static const int periodeRefresh = 6;

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
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              title: Text(snapshot.data!.root.id),
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.home), onPressed: () {
                  while(Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                }
                    ),
                //TODO lock/unlock all
              ],
            ),
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
      title: Text('D ${door.id}'),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          door.state == 'locked'
              ? TextButton(
                  onPressed: () {
                    req.unlockDoor(door);
                    futureTree = req.getTree(widget.id);
                    setState(() {});
                  },
                  child: const Text("unlock"),
                )
              : TextButton(
                  onPressed: () {
                    if (door.closed) {
                      req.lockDoor(door);
                      futureTree = req.getTree(widget.id);
                      setState(() {});
                    } else {
                      message.infoMessage(context, "Can't lock this door because it's opened.");
                    }
                  },
            child: Text(
              "lock",
              style: TextStyle(
                  color: (door.closed)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey),
            ),
                ),
          (!door.closed)
              ? TextButton(
                  onPressed: () {
                    req.closeDoor(door);
                    futureTree = req.getTree(widget.id);
                    setState(() {});
                  },
                  child: const Text("close"),
                )
              : TextButton(
                  onPressed: () {
                    if (door.state == 'unlocked') {
                      req.openDoor(door);
                      futureTree = req.getTree(widget.id);
                      setState(() {});
                    } else {
                      message.infoMessage(context, "Can't open this door because it's locked.");
                    }
                  },
                  child: Text(
                    "open",
                    style: TextStyle(
                        color: (door.state == 'unlocked')
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey),
                  ),
                ),
        ],
      ),
    );
  }
}
