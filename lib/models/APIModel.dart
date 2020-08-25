import 'model.dart';

class APIModel extends Model {
  int id;
  APIModel({this.id});
  APIModel.fromMap(Map map);
  //Map<String, dynamic> toMap();
}
