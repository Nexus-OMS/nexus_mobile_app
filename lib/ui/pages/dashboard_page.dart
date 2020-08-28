import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/models/announcement.dart';
import 'package:nexus_mobile_app/services/api_routes.dart';
import 'package:nexus_mobile_app/services/authorized_client.dart';
import 'package:nexus_mobile_app/ui/components/profile_avatar.dart';
import 'package:nexus_mobile_app/ui/components/tiles/skeleton_tile.dart';
import 'package:nexus_mobile_app/ui/typography.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nexus_mobile_app/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

enum _AnnouncementsState { uninitialized, hasData }

class _DashboardPageState extends State<DashboardPage>
    with AutomaticKeepAliveClientMixin {
  _AnnouncementsState _announcementsState = _AnnouncementsState.uninitialized;
  List<Announcement> announcements = [];
  final EdgeInsets _insets = EdgeInsets.all(12);
  List<dynamic> documents = [
    {'title': 'Operations Order', 'name': 'ops-order'},
    {'title': 'Organization Chart', 'name': 'org-chart'}
  ];

  Future<void> _getAnnouncements() async {
    setState(() {
      _announcementsState = _AnnouncementsState.uninitialized;
      announcements = <Announcement>[];
    });
    var raw_announcements =
        await context.client.get(route: APIRoutes.routes[Announcement]);
    setState(() {
      for (var item in raw_announcements) {
        if (!item['title'].contains('COW')) {
          announcements.add(Announcement.fromMap(item));
        }
      }
      _announcementsState = _AnnouncementsState.hasData;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAnnouncements();
  }

  Future<void> _refreshData() async {
    BlocProvider.of<AuthenticationBloc>(context)
        .add(AuthenticationEventRefresh());
    setState(() {
      documents = [];
    });
    await _getAnnouncements();
    setState(() {
      documents = [
        {'title': 'Operations Order', 'name': 'ops-order'},
        {'title': 'Organization Chart', 'name': 'org-chart'}
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: SafeArea(
            child: RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _DashboardHeaderDelegate(),
          ),
          SliverPersistentHeader(
            delegate: _AnnouncementsHeaderDelegate(),
          ),
          _announcementsBuilder(context),
          SliverPersistentHeader(
            delegate: _DocumentsHeaderDelegate(),
          ),
          _documentsBuilder(context)
        ],
      ),
    )));
  }

  Widget _announcementsBuilder(context) {
    var children = <Widget>[];
    if (_announcementsState == _AnnouncementsState.uninitialized) {
      for (var _ in List(4)) {
        children.add(SkeletonTile(height: 24));
      }
    } else {
      for (var ann in announcements) {
        children.add(_announcementListBuilder(context, ann));
      }
    }
    return SliverList(delegate: SliverChildListDelegate(children));
  }

  Widget _announcementListBuilder(context, Announcement announcement) {
    if (_announcementsState == _AnnouncementsState.uninitialized) {
      return CircularProgressIndicator();
    }
    return Padding(
        padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
        child: Card(
            child: Padding(
                padding: _insets,
                child: Subtitle(announcement.title.replaceAll('_', ' ') +
                    ': ' +
                    announcement.text))));
  }

  Widget _documentsBuilder(context) {
    var children = <Widget>[];
    for (var doc in documents) {
      children.add(Builder(
        builder: (context) {
          return DocumentTile(doc['title'], doc['name']);
        },
      ));
    }
    return SliverList(delegate: SliverChildListDelegate(children));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _AnnouncementsHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [TextTitle('Announcements')]));
  }

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class _DocumentsHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [TextTitle('Documents')]));
  }

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class DocumentTile extends StatefulWidget {
  final String title;
  final String name;
  DocumentTile(this.title, this.name);
  @override
  _DocumentTileState createState() => _DocumentTileState();
}

enum _DocumentState { loading, error, data }

class _DocumentTileState extends State<DocumentTile> {
  String date;
  _DocumentState _state = _DocumentState.loading;

  @override
  void initState() {
    super.initState();
    _getDate();
  }

  void _getDate() async {
    try {
      var raw = await context.client
          .get(route: '/api/v1/f/pdf/${widget.name}.pdf/metadata');
      setState(() {
        date = raw['last_modified'];
        _state = _DocumentState.data;
      });
    } catch (e) {
      setState(() {
        _state = _DocumentState.error;
      });
    }
  }

  Future<String> _findLocalPath() async {
    if (Platform.isAndroid) return '/storage/emulated/0';
    return (await getApplicationDocumentsDirectory()).path;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
        child: Card(
            child: InkWell(
                onTap: () async {
                  final domain = await AuthorizedClient.domain;
                  final url = 'https://$domain/api/v1/f/pdf/${widget.name}.pdf';
                  final path = (await _findLocalPath());
                  final headers = await AuthorizedClient.headers;
                  await FlutterDownloader.enqueue(
                    url: url,
                    headers: headers,
                    savedDir: path,
                    showNotification:
                        true, // show download progress in status bar (for Android)
                    openFileFromNotification:
                        true, // click on notification to open downloaded file (for Android)
                  );
                  if (await canLaunch(url)) {
                    await launch(url, headers: await AuthorizedClient.headers);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Headline(widget.title),
                        Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: _state == _DocumentState.loading
                                ? SkeletonTile(
                                    width: 80,
                                    height: 18,
                                  )
                                : (_state == _DocumentState.error
                                    ? Subtitle('No File')
                                    : Subtitle(date)))
                      ],
                    )))));
  }
}

class _DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                  final user = (state as AuthenticationStateAuthenticated).user;
                  return ProfileAvatar(
                      initials: user.getInitials(), route: user.image_uri);
                }),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    //TODO Settings page
                  },
                )
              ],
            ))
      ],
    ));
  }

  @override
  double get maxExtent => 140;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
