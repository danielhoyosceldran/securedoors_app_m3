import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

import 'tree.dart';

const String BASE_URL = "http://localhost:8080";
final DateFormat DATEFORMATTER = DateFormat('yyyy-MM-ddThh:mm');

Future<String> sendRequest(Uri uri) async {
  final response = await http.get(uri);
// response is NOT a Future because of await
  if (response.statusCode == 200) {
    // server returns an OK response print("statusCode=$response.statusCode");
    print("respone" + response.body);
    return response.body;
  } else {
    print("statusCode=$response.statusCode");
    throw Exception('failed to get answer to request $uri');
  }
}

Future<Tree> getTree(String areaId) async {
  Uri uri = Uri.parse("${BASE_URL}/get_children?$areaId");
  final String responseBody = await sendRequest(uri);
  Map<String, dynamic> decoded = convert.jsonDecode(responseBody);
  print("decoded");
  print(decoded);
  return Tree(decoded);
}

Future<void> lockDoor(Door door) async {
  doorActions(door, 'lock');
}

Future<void> unlockDoor(Door door) async {
  doorActions(door, 'unlock');
}

Future<void> closeDoor(Door door) async {
  doorActions(door, 'close');
}

Future<void> openDoor(Door door) async {
  doorActions(door, 'open');
}

Future<void> doorActions(Door door, String action) async {
// From the simulator : when asking to lock door D1, of parking, the request is
// http://localhost:8080/reader?credential=11343&action=lock
//	&datetime=2023-12-08T09:30&doorId=D1 assert ((action=='lock') | (action=='unlock'));
  String strNow = DATEFORMATTER.format(DateTime.now());
  print(strNow);
  Uri uri = Uri.parse("${BASE_URL}/reader?credential=11343&action=$action"
      "&datetime=$strNow&doorId=${door.id}");
// credential 11343 corresponds to user Ana of Administrator group
  print('lock ${door.id}, uri $uri');
  final String responseBody = await sendRequest(uri);
  print('requests.dart : door ${door.id} is ${door.state}');
}
