import 'model.dart';

class Term extends Model {
  int term;
  @override
  String name;

  Term();

  @override
  String toString() {
    return 'Term{term: $term, name: $name}';
  }

  Term.fromMap(Map<dynamic, dynamic> map) {
    term = map['term'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'term': term, 'name': name};
    return map;
  }
}
