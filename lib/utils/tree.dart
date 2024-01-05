import 'dart:ffi';

abstract class Area{
  late String id;
  late List<dynamic> children;
  Area(this.id, this.children);
}

class Partition extends Area {
  Partition(String id, List<Area>children) : super(id, children);
}

class Space extends Area {
  final List<dynamic>? _doorsInside;
  final Map<String, String>? _doorsInsideInfo;
  Space(String id, List<Door> children, List<dynamic> this._doorsInside, Map<String, String> this._doorsInsideInfo) : super(id, children);

  bool doorsIside() {
    return _doorsInside!.isNotEmpty;
  }
  bool allDoorsLocked() {
    return _doorsInsideInfo!["allLocked"] == "true" ? true : false;
  }
  String numDoors() {
    return _doorsInsideInfo!["numDoors"]!;
  }
}

class Door {
  late String id;
  late bool closed;
  late String state;
  Door({required this.id, this.state="unlocked", this.closed=true});
}

// at the moment this class seems unnecessary but later we will extend it
class Tree {
  late Area root;

  Tree(Map<String, dynamic> decodedTree) {
    // 1 level tree, root and children only, root is either Partition or Space.
    // If Partition children are Partition or Space, that is, Area. If root
    // is a Space, children are Door.
    // There is a JSON field 'class' that tells the type of Area.
    if (decodedTree['class'] == "partition") {
      List<Area> children = <Area>[]; // is growable
      for (Map<String, dynamic> area in decodedTree['areas']) {
        if (area['class'] == "partition") {
          children.add(Partition(area['id'], <Area>[]));
        } else if (area['class'] == "space") {
          children.add(Space(area['id'], <Door>[], area["access_doors"], getSpaceDoorsInfo(area)));
        } else {
          assert(false);
        }
      }
      root = Partition(decodedTree['id'], children);
    } else if (decodedTree['class'] == "space") {
      List<Door> children = <Door>[];
      for (Map<String, dynamic> d in decodedTree['access_doors']) {
        children.add(Door(id: d['id'], state: d['state'], closed: d['closed']));
      }
      root = Space(decodedTree['id'], children, decodedTree["access_doors"], getSpaceDoorsInfo(decodedTree));
    } else {
      assert(false);
    }
  }
}

Map<String, String> getSpaceDoorsInfo(Map<String, dynamic> decodedTree) {
  if (decodedTree["class"] != "space") return {};
  bool allLocked = true;
  bool allUnloked = true;

  for (Map<String, dynamic> door in decodedTree["access_doors"]) {
    if (door["state"] == "unlocked") {
      allLocked = false;
    } else if (door["state"] == "locked") {
      allUnloked = false;
    }
  }

  return {
    "numDoors": decodedTree["access_doors"].length.toString(),
    "allLocked": allLocked.toString()
  };
}