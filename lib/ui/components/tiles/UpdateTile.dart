import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/Update.dart';
import 'package:nexus_mobile_app/ui/components/ProfileAvatar.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NErrorTile.dart';
import 'package:nexus_mobile_app/ui/pages/main/UpdatesPage.dart';

class UpdateTile extends StatelessWidget {
  final Update update;
  final Function(Update) onPressed;

  UpdateTile({@required this.update, this.onPressed});
  final EdgeInsets textInsets = EdgeInsets.only(top: 4, bottom: 4);

  @override
  Widget build(BuildContext context) {
    try {
      return InkWell(
          child: Row(
            children: <Widget>[
              ProfileAvatar(
                  initials: update.user.getInitials(),
                  route: update.user.image_uri),
              Flexible(
                child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: textInsets,
                          child: Text(
                            update.update_title,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontSize: 22),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: textInsets,
                          child: Text(
                            update.user.getFullName() +
                                ' · ' +
                                update.updated_at.split(' ').first,
                            style: Theme.of(context).textTheme.caption,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
          onTap: () =>
              onPressed(update) ??
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdatePage(update)));
              });
    } catch (e) {
      print(e);
      return NErrorTile(error_name: 'update');
    }
  }
}
