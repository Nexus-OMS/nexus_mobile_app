import 'package:nexus_mobile_app/models/APIModel.dart';

import 'Permission.dart';
import 'Position.dart';
import 'Level.dart';
import 'Rank.dart';

class User extends APIModel {
  int id;
  String un;
  Level level;
  int flight;
  Rank rank;
  Position position;
  String firstName;
  String lastName;
  String phone;
  String school;
  String major;
  String hometown;
  String image_uri;

  List<Permission> permissions;

  User();

  String getFullName() {
    return this.firstName + " " + this.lastName;
  }

  String getInitials() {
    return this.firstName[0] + this.lastName[0];
  }

  @override
  User.fromMap(Map map) {
    id = map['o_id'];
    un = map['un'];
    level = nullInt(map['level'], process: (n) => Level.fromMap(map['level']));
    rank = nullInt(map['rank'], process: (n) => Rank.fromMap(map['rank']));
    position =
        nullInt(map['primary_position'], process: (n) => Position.fromMap(n));
    firstName = map['firstName'];
    lastName = map['lastName'];
    phone = nullInt(map['phone']);
    school = map['school'];
    major = map['major'];
    hometown = map['hometown'];
    if (map['image_uri'] != null) {
      if ((map['image_uri'] as String).contains('images/profile-pic.png'))
        image_uri = null;
      else
        image_uri = map['image_uri'];
    } else {
      image_uri = null;
    }
  }

  dynamic nullInt(dynamic w, {Function process}) {
    return (w == null || w is int)
        ? null
        : (process != null && w is Map<dynamic, dynamic> ? process(w) : w);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'o_id': id,
      'un': un,
      'level': level != null ? level.id : null,
      'rank': rank != null ? rank.id : null,
      'primary_position': position != null ? position.id : null,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'school': school,
      'major': major,
      'hometown': hometown,
      'image_uri': image_uri
    };
    return map;
  }

  @override
  APIModel get(int id) {
    // TODO: implement get
    return null;
  }
}
