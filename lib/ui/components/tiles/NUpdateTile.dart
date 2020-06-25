import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/models/Update.dart';
import 'package:nexus_mobile_app/providers/UserProvider.dart';
import 'package:nexus_mobile_app/ui/components/ProfileAvatar.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NErrorTile.dart';
import 'package:nexus_mobile_app/ui/pages/UpdatesPage.dart';

class NUpdateTile extends StatelessWidget {
  final Update update;

  NUpdateTile({@required this.update});
  EdgeInsets textInsets = EdgeInsets.only(top: 4, bottom: 4);

  UserProvider userProvider;
  User user;

  @override
  Widget build(BuildContext context) {
    try {
      User user = User.fromMap(update.user);
      return new GestureDetector(
          child: new Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: new Border(
                      bottom: BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ))),
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
                                update.update_title,
                                style: Theme.of(context).textTheme.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            new Padding(
                              padding: textInsets,
                              child: new Text(
                                update.update_text,
                                style: Theme.of(context).textTheme.body1,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            new Padding(
                              padding: textInsets,
                              child: new Text(
                                user.getFullName() +
                                    " · " +
                                    update.updated_at.split(' ').first,
                                style: Theme.of(context).textTheme.caption,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              )),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new UpdatePage(update)));
          });
    } catch (e) {
      print(e);
      return new NErrorTile(error_name: 'update');
    }
  }
}
