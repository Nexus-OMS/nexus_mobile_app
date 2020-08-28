import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/repositories/organization_repository.dart';
import 'package:nexus_mobile_app/bloc/user_bloc/user_bloc.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/ui/components/profile_avatar.dart';
import 'package:nexus_mobile_app/ui/components/tiles/error_tile.dart';
import 'package:nexus_mobile_app/ui/theme.dart';
import 'package:nexus_mobile_app/extensions.dart';
import 'package:nexus_mobile_app/ui/typography.dart';
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
  OrganizationRepository rep;
  @override
  void initState() {
    super.initState();
    rep = OrganizationRepository(context.client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (BuildContext context) => UserBloc(rep, widget.user_id),
            child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserStateUninitialized) {
                context.bloc<UserBloc>().add(UserEventRefresh(Completer()));
              }
              return CustomScrollView(
                slivers: [SliverAppBar(), ..._buildContent(state)],
              );
            })));
  }

  List<Widget> _buildContent(state) {
    if (state is UserStateHasData) {
      if (state.user != null) {
        return [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Center(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: ProfileAvatar(
                          initials: state.user.getInitials(),
                          route: state.user.image_uri,
                          size: 80))),
              Center(
                  child: Padding(
                padding: EdgeInsets.all(2),
                child: Text(
                  '${state.user.rank?.name} ${state.user.getFullName()}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 28),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
              Center(
                child: Text(
                  state.user.position?.name ?? 'N/A',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 20),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getTiles(state.user))
            ]),
          )
        ];
      }
    } else if (state is UserStateError) {
      return [
        SliverFillRemaining(
            child: NErrorTile(
          error_name: 'user',
        ))
      ];
    }
    return [
      SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
    ];
  }

  List<Widget> _getTiles(User user) {
    final key = GlobalKey<ScaffoldState>();
    var children = <Widget>[];

    if (user.phone != null) {
      children.add(Expanded(
          child: Padding(
              padding: EdgeInsets.all(12),
              child: OutlineButton(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: user.phone));
                    key.currentState.showSnackBar(SnackBar(
                      content: Text('Copied to Clipboard'),
                    ));
                  },
                  onPressed: () => openRequest('sms:${user.phone}'),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text(_parsePhone(user.phone),
                          style: Theme.of(context).textTheme.button.copyWith(
                                fontWeight: FontWeight.w800,
                              )),
                      Subtitle('Phone'),
                    ]),
                  )))));
    }
    children.add(Expanded(
        child: Padding(
            padding: EdgeInsets.all(12),
            child: OutlineButton(
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: user.un ?? ' '));
                  key.currentState.showSnackBar(SnackBar(
                    content: Text('Copied to Clipboard'),
                  ));
                },
                onPressed: () => openRequest('mailto:${user.un}@rit.edu'),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(children: [
                    Text(user.un,
                        style: Theme.of(context).textTheme.button.copyWith(
                              fontWeight: FontWeight.w800,
                            )),
                    Subtitle('E-Mail'),
                  ]),
                )))));
    return children;
  }

  void openRequest(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _parsePhone(String phone) {
    if (phone.length < 10) return phone;
    return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
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
