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
    level = map['level'] == null ? null : Level.fromMap(map['level']);
    rank = map['rank'] == null ? null : Rank.fromMap(map['rank']);
    position = map['primary_position'] == null
        ? null
        : Position.fromMap(map['primary_position']);
    firstName = map['firstName'];
    lastName = map['lastName'];
    phone = nullCheck(map['phone']);
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

  String nullCheck(dynamic w) {
    return w == null ? null : w;
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
