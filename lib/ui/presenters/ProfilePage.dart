import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/providers/UserProvider.dart';
import 'package:nexus_mobile_app/ui/components/ImageLoader.dart';
import 'package:nexus_mobile_app/ui/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'dart:math' as math;

class ProfilePage extends StatefulWidget {
  int user_id;
  ProfilePage(this.user_id);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    int user_id = this.widget.user_id;
    User user = userProvider.users.firstWhere((user) => user.id == user_id);
    String image_uri;
    if (user.image_uri != null) {
      if (user.image_uri.contains('profile_placeholder')) {
        image_uri = user.image_uri;
      } else {
        image_uri = '/api' + user.image_uri;
      }
    }

    return new Scaffold(
      body: new CustomScrollView(slivers: <Widget>[
        new SliverAppBar(
          pinned: true,
          //snap: true,
          floating: false,
          expandedHeight: 330.0,
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: new FlexibleSpaceBar(
            background: ImageLoader(route: image_uri),
            title: Text(user.getFullName()),
            centerTitle: true,
            collapseMode: CollapseMode.parallax,
          ),
        ),
        new SliverPersistentHeader(
          delegate: new _ProfilePageHeaderDelegate(
              collapsedHeight: 58, expandedHeight: 58, vsync: this, user: user),
          pinned: true,
        ),
        new SliverList(
            delegate: new SliverChildBuilderDelegate(
                (context, index) => _getTile(context, user, index),
                childCount: 3))
      ]),
      floatingActionButton: new FloatingActionButton(
          onPressed: () async {}, child: new Icon(Icons.edit)),
    );
  }

  _getTile(BuildContext context, User user, int index) {
    TextStyle titleStyle = new TextStyle(fontSize: 12.0);
    TextStyle subTitleStyle =
        new TextStyle(fontSize: 16.0, color: new Color(0xFF111111));
    final key = new GlobalKey<ScaffoldState>();

    if (index == 0) {
      return new Card(
          elevation: 3.0,
          child: new Column(children: <Widget>[
            new GestureDetector(
              onLongPress: () {
                Clipboard.setData(new ClipboardData(
                    text: user.phone != null ? user.phone : ' '));
                key.currentState.showSnackBar(new SnackBar(
                  content: new Text("Copied to Clipboard"),
                ));
              },
              child: new ListTile(
                title: new Text('Phone', style: titleStyle),
                subtitle: new Text(user.phone != null ? user.phone : 'N/A',
                    style: subTitleStyle),
              ),
            ),
            new GestureDetector(
              onLongPress: () {
                Clipboard.setData(new ClipboardData(
                    text: user.un != null ? user.un + '@rit.edu' : ' '));
                key.currentState.showSnackBar(new SnackBar(
                  content: new Text("Copied to Clipboard"),
                ));
              },
              child: new ListTile(
                title: new Text('E-Mail', style: titleStyle),
                subtitle: new Text(
                    user.un != null ? user.un + '@rit.edu' : 'N/A',
                    style: subTitleStyle),
              ),
            ),
          ]));
    } else if (index == 1) {
      return new Card(
          elevation: 3.0,
          child: new Column(children: <Widget>[
            new ListTile(
              title: new Text('School', style: titleStyle),
              subtitle: new Text(user.school != null ? user.school : 'N/A',
                  style: subTitleStyle),
            ),
            new ListTile(
              title: new Text('Major', style: titleStyle),
              subtitle: new Text(user.major != null ? user.major : 'N/A',
                  style: subTitleStyle),
            ),
            new ListTile(
              title: new Text('Hometown', style: titleStyle),
              subtitle: new Text(user.hometown != null ? user.hometown : 'N/A',
                  style: subTitleStyle),
            ),
          ]));
    } else if (index == 2) {
      return new Card(
          elevation: 3.0,
          child: new Column(children: <Widget>[
            new ListTile(
              title: new Text('Rank', style: titleStyle),
              subtitle: new Text(user.rank != null ? user.rank.name : 'N/A',
                  style: subTitleStyle),
            ),
            new ListTile(
              title: new Text('AS Class', style: titleStyle),
              subtitle: new Text(user.level != null ? user.level.name : 'N/A',
                  style: subTitleStyle),
            ),
            new ListTile(
              title: new Text('Position', style: titleStyle),
              subtitle: new Text(
                  user.position != null ? user.position.name : 'N/A',
                  style: subTitleStyle),
            ),
          ]));
    } else if (index == 3) {
      return new Card(
        elevation: 3.0,
      );
    }
  }
}

class _ProfilePageHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ProfilePageHeaderDelegate({
    @required this.collapsedHeight,
    @required this.expandedHeight,
    @required this.user,
    @required this.vsync,
  });

  final double expandedHeight;
  final double collapsedHeight;
  User user;
  TickerProvider vsync;

  @override
  double get minExtent => collapsedHeight;
  @override
  double get maxExtent => math.max(expandedHeight, minExtent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Padding(
        padding: new EdgeInsets.only(bottom: 32.0),
        child: new ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            new IconButton(
                icon: new Icon(Icons.message),
                onPressed: user.phone != null
                    ? () async {
                        await launch('sms:' + user.phone);
                      }
                    : null,
                color: NexusTheme.primary,
                disabledColor: new Color.fromARGB(255, 220, 220, 220)),
            new IconButton(
              icon: new Icon(Icons.phone),
              onPressed: user.phone != null
                  ? () async {
                      await launch('tel:' + user.phone);
                    }
                  : null,
              color: NexusTheme.primary,
              disabledColor: new Color(0xDDFFFFFF),
            ),
            new IconButton(
              icon: new Icon(Icons.mail),
              onPressed: user.un != null
                  ? () async {
                      await launch('mailto:' + user.un + '@rit.edu');
                    }
                  : null,
              color: NexusTheme.primary,
              disabledColor: new Color(0xDDFFFFFF),
            )
          ],
        ));
  }

  @override
  bool shouldRebuild(_ProfilePageHeaderDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        collapsedHeight != oldDelegate.collapsedHeight;
  }
}
