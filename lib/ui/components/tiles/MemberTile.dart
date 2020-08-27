import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/ui/components/ProfileAvatar.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NErrorTile.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/ProfilePage.dart';

class MemberTile extends StatelessWidget {
  final User user;
  final Function(User) onPressed;

  MemberTile({@required this.user, this.onPressed});

  final EdgeInsets textInsets = EdgeInsets.only(top: 4, bottom: 4);
  final EdgeInsets subTextInsets = EdgeInsets.only(top: 2, bottom: 2);

  @override
  Widget build(BuildContext context) {
    try {
      return InkWell(
          child: Container(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  ProfileAvatar(
                      initials: user.getInitials(), route: user.image_uri),
                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: textInsets,
                              child: Text(
                                user.getFullName(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontSize: 22),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            user.level != null
                                ? Padding(
                                    padding: subTextInsets,
                                    child: Text(
                                      user.level.name +
                                          (user.position == null
                                              ? ''
                                              : ' · ' + user.position.name),
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
          onTap: () =>
              onPressed(user) ??
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(user.id)));
              });
    } catch (e, stack) {
      print(e);
      print(stack);
      return NErrorTile(error_name: 'user');
    }
  }
}
