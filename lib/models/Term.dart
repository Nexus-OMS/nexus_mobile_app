import 'model.dart';

class Term extends Model {
  int term;
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
    Map<String, dynamic> map = {'term': term, 'name': name};
    return map;
  }
}
