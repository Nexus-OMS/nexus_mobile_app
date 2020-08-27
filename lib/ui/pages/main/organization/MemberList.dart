import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/ui/components/tiles/MemberTile.dart';
import 'package:nexus_mobile_app/ui/components/tiles/SkeletonTile.dart';

class MemberList extends StatelessWidget {
  final List<User> users;
  MemberList(this.users);
  @override
  Widget build(BuildContext context) {
    if (users == null) {
      return SliverList(
        delegate: SliverChildListDelegate([SkeletonTile(height: 38)]),
      );
    } else if (users.isEmpty) {
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
            padding: EdgeInsets.all(16.0),
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
      Widget widget = MemberTile(user: users[index]);
      if (index == 0) {
        widget = Padding(padding: EdgeInsets.only(top: 8), child: widget);
      }
      return widget;
    }, childCount: users.length));
  }
}
