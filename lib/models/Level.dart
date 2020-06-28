import 'package:nexus_mobile_app/models/APIModel.dart';

final String api_route = '/api/v1/level';
final String tableName = 'levels';

class Level extends APIModel {
  int id;
  String name;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'o_id': id, 'name': name};
    return map;
  }

  Level.fromMap(Map map) {
    id = map['o_id'];
    name = map['name'];
  }
}
