import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import '../utils/tree.dart';
import 'package:securedoors_app/data/currentUser.dart';

const String BASE_URL = "http://localhost:8080";
final DateFormat DATEFORMATTER = DateFormat('yyyy-MM-ddThh:mm');

Future<String> sendRequest(Uri uri) async {
  final response = await http.get(uri);
// response is NOT a Future because of await
  if (response.statusCode == 200) {
    // server returns an OK response print("statusCode=$response.statusCode");
    return response.body;
  } else {
    //print("statusCode=$response.statusCode");
    throw Exception('failed to get answer to request $uri');
  }
}

Future<Tree> getTree(String areaId) async {
  Uri uri = Uri.parse("$BASE_URL/get_children?$areaId");
  final String responseBody = await sendRequest(uri);
  Map<String, dynamic> decoded = convert.jsonDecode(responseBody);
  return Tree(decoded);
}

Future<bool> lockDoor(Door door) async {
  return doorActions(door, 'lock');
}

Future<bool> unlockDoor(Door door) async {
  return doorActions(door, 'unlock');
}

Future<bool> closeDoor(Door door) async {
  return doorActions(door, 'close');
}

Future<bool> openDoor(Door door) async {
  return doorActions(door, 'open');
}

Future<bool> lockAll(Area area) async {
  return areaActions(area, 'lock');
}

Future<bool> unlockAll(Area area) async {
  return areaActions(area, 'unlock');
}

Future<bool> doorActions(Door door, String action) async {
// From the simulator : when asking to lock door D1, of parking, the request is
// http://localhost:8080/reader?credential=11343&action=lock
//	&datetime=2023-12-08T09:30&doorId=D1 assert ((action=='lock') | (action=='unlock'));
  String strNow = DATEFORMATTER.format(DateTime.now());
  Uri uri = Uri.parse("$BASE_URL/reader?credential=${getCurrentUserCredentials()}&action=$action"
      "&datetime=$strNow&doorId=${door.id}");
// credential 11343 corresponds to user Ana of Administrator group
  //print('lock ${door.id}, uri $uri');
  final String responseBody = await sendRequest(uri);
  //print('actionsRequests.dart : door ${door.id} is ${door.state}');
  return convert.jsonDecode(responseBody)["authorized"];
}

Future<bool> areaActions(Area area, String action) async {
  String strNow = DATEFORMATTER.format(DateTime.now());
  Uri uri = Uri.parse("$BASE_URL/area?credential=${getCurrentUserCredentials()}&action=$action"
      "&datetime=$strNow&doorId=${area.id}");
// credential 11343 corresponds to user Ana of Administrator group
  final String responseBody = await sendRequest(uri);
  return convert.jsonDecode(responseBody)["authorized"];
}
