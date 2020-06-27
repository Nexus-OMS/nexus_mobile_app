import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/ui/components/ProfileAvatar.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NErrorTile.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/ProfilePage.dart';

class MemberTile extends StatelessWidget {
  final User user;

  MemberTile({@required this.user});

  EdgeInsets textInsets = EdgeInsets.only(top: 4, bottom: 4);
  EdgeInsets subTextInsets = EdgeInsets.only(top: 2, bottom: 2);

  @override
  Widget build(BuildContext context) {
    try {
      return new GestureDetector(
          child: new Container(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: new Row(
                children: <Widget>[
                  new ProfileAvatar(
                      initials: user.getInitials(), route: user.image_uri),
                  new Flexible(
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 16.0, right: 16.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: textInsets,
                              child: new Text(
                                user.getFullName(),
                                style: Theme.of(context).textTheme.headline6,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            user.level != null
                                ? Padding(
                                    padding: subTextInsets,
                                    child: new Text(
                                      user.level.name +
                                          (user.position == null
                                              ? ''
                                              : " · " + user.position.name),
                                      style:
                                          Theme.of(context).textTheme.caption,
                                      maxLines: 1,
                                    ),
                                  )
                                : Container(),
                          ],
                        )),
                  )
                ],
              )),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage(user.id)));
          });
    } catch (e, stack) {
      print(e);
      print(stack);
      return NErrorTile(error_name: 'user');
    }
  }
}
