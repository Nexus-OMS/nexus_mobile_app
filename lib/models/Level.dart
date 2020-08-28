import 'package:nexus_mobile_app/models/api_model.dart';

final String api_route = '/api/v1/level';
final String tableName = 'levels';

class Level extends APIModel {
  @override
  int id;
  @override
  String name;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'o_id': id, 'name': name};
    return map;
  }

  Level.fromMap(Map map) {
    id = map['o_id'];
    name = map['name'];
  }
}
