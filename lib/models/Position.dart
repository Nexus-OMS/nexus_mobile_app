class Position {
  int id;
  String name;
  String symbol;

  Position();

  Position.fromMap(Map map){
    id = map['o_id'];
    name = map['name'];
    symbol = map['symbol'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'o_id': id,
      'name': name,
      'symbol': symbol,
    };
    return map;
  }
}
