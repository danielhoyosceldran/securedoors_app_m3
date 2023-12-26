import 'package:flutter/material.dart';
import 'package:securedoors_app/tree.dart';

class ScreenPartition extends StatefulWidget {
  const ScreenPartition({Key? key}) : super(key: key);

  @override
  State<ScreenPartition> createState() => _ScreenPartitionState();
}

class _ScreenPartitionState extends State<ScreenPartition> {
  late Tree tree;

  @override
  void initState() {
    super.initState();
    tree = getTree("building");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tree.root.id),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.home),
              onPressed: () {}
            // TODO go home page = root
          ),
          //TODO other actions
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: tree.root.children.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildRow(tree.root.children[index], index),
        separatorBuilder: (BuildContext context, int index) =>
        const Divider(),
      ),
    );
  }

  Widget _buildRow(Area area, int index) {
    assert (area is Partition || area is Space);
    if (area is Partition) {
      return ListTile(
        title: Text('P ${area.id}'),
        onTap: () => {},
        // TODO, navigate down to show children areas
      );
    } else {
      return ListTile(
        title: Text('S ${area.id}'),
        onTap: () => {},
        // TODO, navigate down to show children doors
      );
    }
  }
}
