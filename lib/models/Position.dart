class Position {
  int id;
  String name;
  String symbol;
  int position_superior;
  String ad_group;
  int unit;
  List<Position> children;

  Position();

  Position.fromMap(Map map) {
    id = map['o_id'];
    name = map['name'];
    symbol = map['symbol'];
    position_superior = map['position_superior'];
    ad_group = map['ad_group'];
    unit = map['unit'];
    children = List<Position>();
    if (map['children'] != null)
      map['children'].forEach((ent) => children.add(Position.fromMap(ent)));
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'o_id': id,
      'name': name,
      'symbol': symbol,
      'position_superior': position_superior,
      'ad_group': ad_group,
      'unit': unit
    };
    return map;
  }
}
