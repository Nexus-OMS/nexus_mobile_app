class Update {
  int id;

  //String image_uri;
  String update_title;
  String update_text;
  String updated_at;
  dynamic user;
  //bool published;
  int user_id;

  Update();

  Update.fromMap(Map map){
    id = map['o_id'];
    update_title = map['update_title'];
    update_text = (map['update_text'] as String);
    update_text = update_text == null ? null : update_text.replaceAll("\\", "");
    updated_at = map['updated_at'];
    user_id = map['user_id'];
    user = map['user'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'o_id': id,
      'update_title': update_title,
      'update_text': update_text,
      //'published': published,
      'user_id': user_id,
    };
    return map;
  }

  @override
  String toString() {
    return 'Update{id: $id, update_title: $update_title, update_text: $update_text, user_id: $user_id}';
  }
}
