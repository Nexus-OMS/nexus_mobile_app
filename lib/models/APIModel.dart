abstract class APIModel {
  APIModel();
  APIModel.fromMap(Map map);
  Map<String, dynamic> toMap();

  APIModel get(int id);
  
}