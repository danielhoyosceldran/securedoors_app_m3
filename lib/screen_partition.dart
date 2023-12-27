import 'package:flutter/material.dart';
import 'package:securedoors_app/tree.dart';
import 'package:securedoors_app/screen_space.dart';

class ScreenPartition extends StatefulWidget {
  final String id;
  const ScreenPartition({
    Key? key,
    required this.id
  }) : super(key: key);

  @override
  State<ScreenPartition> createState() => _ScreenPartitionState();
}

class _ScreenPartitionState extends State<ScreenPartition> {
  late Tree tree;

  @override
  void initState() {
    super.initState();
    tree = getTree(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tree.root.id),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
        onTap: () => _navigateDownPartition(area.id),
      );
    } else {
      return ListTile(
        title: Text('S ${area.id}'),
        onTap: () => _navigateDownSpace(area.id),
      );
    }
  }

  void _navigateDownPartition(String childId) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (context) => ScreenPartition(id: childId,))
    );
  }

  void _navigateDownSpace(String childId) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (context) => ScreenSpace(id: childId,))
    );
  }
}
