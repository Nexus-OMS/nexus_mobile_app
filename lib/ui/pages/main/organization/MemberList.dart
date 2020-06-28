import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/ui/components/tiles/MemberTile.dart';

class MemberList extends StatelessWidget {
  final List<User> users;
  MemberList(this.users);
  @override
  Widget build(BuildContext context) {
    if (this.users == null) {
      return SliverList(
        delegate: SliverChildListDelegate(
            [Center(child: CircularProgressIndicator())]),
      );
    } else if (this.users.length == 0) {
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1))),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(70, 220, 220, 220),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.grey,
                  ),
                ],
              ),
            ));
      }, childCount: 1));
    }
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return MemberTile(user: this.users[index]);
    }, childCount: users.length));
  }
}
