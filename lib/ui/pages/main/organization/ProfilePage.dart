import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/organization_bloc/organization_bloc.dart';
import 'package:nexus_mobile_app/bloc/user_bloc/user_bloc.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/ui/components/ImageLoader.dart';
import 'package:nexus_mobile_app/ui/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'dart:math' as math;

class ProfilePage extends StatefulWidget {
  final int user_id;
  ProfilePage(this.user_id);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var rep = BlocProvider.of<OrganizationBloc>(context).repository;
    return Scaffold(
        body: BlocProvider(
            create: (BuildContext context) => UserBloc(rep, widget.user_id),
            child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserStateUninitialized) {
                //loading
                context.bloc<UserBloc>().add(UserEventRefresh(Completer()));
              }
              if (state is UserStateHasData) {
                if (state.user != null) {
                  return CustomScrollView(slivers: <Widget>[
                    SliverAppBar(
                      pinned: true,
                      //snap: true,
                      floating: false,
                      expandedHeight: 330.0,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      flexibleSpace: FlexibleSpaceBar(
                        background: ImageLoader(route: state.user.image_uri),
                        title: Text(state.user.getFullName()),
                        centerTitle: true,
                        collapseMode: CollapseMode.parallax,
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _ProfilePageHeaderDelegate(
                          collapsedHeight: 58,
                          expandedHeight: 58,
                          vsync: this,
                          user: state.user),
                      pinned: true,
                    ),
                  ]);
                } else {
                  Center(child: CircularProgressIndicator());
                }
              }
              return Center(child: Text('ERROR'));
            })));
  }

  Widget _getTile(BuildContext context, User user, int index) {
    var titleStyle = TextStyle(fontSize: 12.0);
    var subTitleStyle = TextStyle(fontSize: 16.0, color: Color(0xFF111111));
    final key = GlobalKey<ScaffoldState>();

    if (index == 0) {
      return Card(
          elevation: 3.0,
          child: Column(children: <Widget>[
            GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: user.phone ?? ' '));
                key.currentState.showSnackBar(SnackBar(
                  content: Text('Copied to Clipboard'),
                ));
              },
              child: ListTile(
                title: Text('Phone', style: titleStyle),
                subtitle: Text(user.phone ?? 'N/A', style: subTitleStyle),
              ),
            ),
            GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(
                    text: user.un != null ? user.un + '@rit.edu' : ' '));
                key.currentState.showSnackBar(SnackBar(
                  content: Text('Copied to Clipboard'),
                ));
              },
              child: ListTile(
                title: Text('E-Mail', style: titleStyle),
                subtitle: Text(user.un != null ? user.un + '@rit.edu' : 'N/A',
                    style: subTitleStyle),
              ),
            ),
          ]));
    } else if (index == 1) {
      return Card(
          elevation: 3.0,
          child: Column(children: <Widget>[
            ListTile(
              title: Text('School', style: titleStyle),
              subtitle: Text(user.school ?? 'N/A', style: subTitleStyle),
            ),
            ListTile(
              title: Text('Major', style: titleStyle),
              subtitle: Text(user.major ?? 'N/A', style: subTitleStyle),
            ),
            ListTile(
              title: Text('Hometown', style: titleStyle),
              subtitle: Text(user.hometown ?? 'N/A', style: subTitleStyle),
            ),
          ]));
    } else if (index == 2) {
      return Card(
          elevation: 3.0,
          child: Column(children: <Widget>[
            ListTile(
              title: Text('Rank', style: titleStyle),
              subtitle: Text(user.rank != null ? user.rank.name : 'N/A',
                  style: subTitleStyle),
            ),
            ListTile(
              title: Text('AS Class', style: titleStyle),
              subtitle: Text(user.level != null ? user.level.name : 'N/A',
                  style: subTitleStyle),
            ),
            ListTile(
              title: Text('Position', style: titleStyle),
              subtitle: Text(user.position != null ? user.position.name : 'N/A',
                  style: subTitleStyle),
            ),
          ]));
    } else if (index == 3) {
      return Card(
        elevation: 3.0,
      );
    }
    return Container();
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
    return Padding(
        padding: EdgeInsets.only(bottom: 32.0),
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.message),
                onPressed: user.phone != null
                    ? () async {
                        await launch('sms:' + user.phone);
                      }
                    : null,
                color: NexusTheme.primary,
                disabledColor: Color.fromARGB(255, 220, 220, 220)),
            IconButton(
              icon: Icon(Icons.phone),
              onPressed: user.phone != null
                  ? () async {
                      await launch('tel:' + user.phone);
                    }
                  : null,
              color: NexusTheme.primary,
              disabledColor: Color(0xDDFFFFFF),
            ),
            IconButton(
              icon: Icon(Icons.mail),
              onPressed: user.un != null
                  ? () async {
                      await launch('mailto:' + user.un + '@rit.edu');
                    }
                  : null,
              color: NexusTheme.primary,
              disabledColor: Color(0xDDFFFFFF),
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
