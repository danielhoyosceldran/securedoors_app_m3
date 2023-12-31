import 'package:flutter/material.dart';
import 'package:securedoors_app/utils/tree.dart';
import 'package:securedoors_app/requests/actionsRequests.dart' as req;
import 'package:securedoors_app/screen_space.dart';
import 'dart:async';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:securedoors_app/utils/messages.dart' as message;
import 'package:securedoors_app/widgets/widget_appBar.dart';

class ScreenPartition extends StatefulWidget {
  final String id;
  String? profilePhoto;

  ScreenPartition({Key? key, required this.id, this.profilePhoto = "lib/assets/users/guest.jpg"}) : super(key: key);

  @override
  State<ScreenPartition> createState() => _ScreenPartitionState();
}

class _ScreenPartitionState extends State<ScreenPartition> {
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

  void _refresh() async {
    futureTree = req.getTree(widget.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    futureTree = req.getTree(widget.id);
    _activateTimer();
  }

  // future with listview
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
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data!.root.children.length,
                itemBuilder: (BuildContext context, int i) =>
                    _buildRow(snapshot.data!.root.children[i], i),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
              floatingActionButton: SpeedDial(
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).colorScheme.onPrimary,
                ), //const Text("actions"),
                children: [
                  SpeedDialChild(
                      label: "Lock All",
                      child: const Icon(Icons.lock_outline),
                      onTap: () {
                        req.lockAll(snapshot.data!.root).then((value) =>
                        {if (!value) message.credentialsError(context)});
                        futureTree = req.getTree(widget.id);
                        setState(() {});
                        message.infoMessage(
                            context, "All ${widget.id} doors locked!");
                      }),
                  SpeedDialChild(
                      label: "Unlock All",
                      child: const Icon(Icons.lock_open_outlined),
                      onTap: () {
                        req.unlockAll(snapshot.data!.root).then((value) =>
                        {if (!value) message.credentialsError(context)});
                        futureTree = req.getTree(widget.id);
                        setState(() {});
                        message.infoMessage(
                            context, "All ${widget.id} doors unlocked!");
                      }),
                ],
              ));
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

  Widget _buildRow(Area area, int index) {
    assert(area is Partition || area is Space);
    if (area is Partition) {
      return ListTile(
        title: Text(area.id),
        leading: const Icon(Icons.space_dashboard_outlined),
        onTap: () => _navigateDownPartition(area.id),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
        ),
      );
    } else {
      return ListTile(
        title: Text(area.id),
        leading: const Icon(Icons.space_bar_outlined),
        onTap: () => _navigateDownSpace(area.id),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //if (area.children.isEmpty) const Text("No doors"),
            const SizedBox(width: 20,),
            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
          ],
        )
      );
    }
  }

  Route _forwardRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _navigateDownPartition(String childId) {
    Navigator.of(context)
        .push(_forwardRoute(ScreenPartition(id: childId, profilePhoto: widget.profilePhoto,)))
        .then((var value) {
      _refresh();
    });
  }

  void _navigateDownSpace(String childId) {
    Navigator.of(context)
        .push(_forwardRoute(ScreenSpace(id: childId, profilePhoto: widget.profilePhoto,)))
        .then((var value) {
      _refresh();
    });
  }
}
