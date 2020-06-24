class Rank {
  int id;
  String name;

  Rank();

  Rank.fromMap(Map map){
    id = map['o_id'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'o_id': id,
      'name': name
    };
    return map;
  }
}
