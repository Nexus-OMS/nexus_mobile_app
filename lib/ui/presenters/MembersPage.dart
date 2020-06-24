import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/providers/LevelProvider.dart';
import 'package:nexus_mobile_app/providers/UserProvider.dart';
import 'package:nexus_mobile_app/ui/components/NFilterTabBar.dart';
import 'package:nexus_mobile_app/ui/components/NSliverIconButton.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NMemberTile.dart';
import 'package:nexus_mobile_app/ui/components/tiles/SkeletonTile.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'dart:math' as math;
import 'package:nexus_mobile_app/NColors.dart';
import 'package:provider/provider.dart';

class MembersPage extends StatefulWidget {
  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage>
    with TickerProviderStateMixin {
  TabController tabController;
  LevelProvider levelProvider;
  UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    levelProvider = Provider.of<LevelProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    tabController = new TabController(
        length: 1 +
            (levelProvider.levels == null ? 0 : levelProvider.levels.length),
        vsync: this)
      ..addListener(() {
        if (tabController.index == 0) {
        } else {}
      });

    bool _floating = false;

    return new Scaffold(
      body: new RefreshIndicator(
          onRefresh: () async {
            return levelProvider.retreive();
          },
          child: new CustomScrollView(slivers: <Widget>[
            new SliverAppBar(
              pinned: true,
              //snap: true,
              floating: _floating,
              expandedHeight: 100.0,
              actions: <Widget>[
                //new NSearchIconButton(),
              ],
              elevation: 0,
              leading: new NSliverIconButton(
                  onPressed: null, icon: Icon(OMIcons.menu)),
              backgroundColor: NColors.primary,
              flexibleSpace: new FlexibleSpaceBar(
                title: Text(
                  'Members',
                  style: TextStyle(color: Colors.black),
                ),
                collapseMode: CollapseMode.parallax,
              ),
            ),
            levelProvider.levels == null
                ? null
                : new SliverPersistentHeader(
                    delegate: new _UserPageHeaderDelegate(
                        collapsedHeight: 36,
                        expandedHeight: 36,
                        controller: tabController,
                        levelProvider: levelProvider),
                    pinned: true,
                  ),
            new SliverList(
                delegate: new SliverChildBuilderDelegate(
                    (context, index) => _makeSkeletonTile(context),
                    childCount: 6)),
          ])),
    );
  }

  Widget _makeTile(context, User user) {
    return new NMemberTile(user: user);
  }

  Widget _makeSkeletonTile(context) {
    return new SkeletonTile();
  }

  SliverList _makeMembersList() {
    return new SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {},
            childCount: userProvider.users.length));
  }
}

class LoadableListBuilderDelegate extends SliverChildBuilderDelegate {
  LoadableListBuilderDelegate(builder) : super(builder);
}

class _UserPageHeaderDelegate extends SliverPersistentHeaderDelegate {
  _UserPageHeaderDelegate({
    @required this.collapsedHeight,
    @required this.expandedHeight,
    @required this.levelProvider,
    @required this.controller,
  });

  final double expandedHeight;
  final double collapsedHeight;
  LevelProvider levelProvider;
  TabController controller;
  List<Tab> tabs;

  @override
  double get minExtent => collapsedHeight;
  @override
  double get maxExtent => math.max(expandedHeight, minExtent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    tabs = [new Tab(text: 'All')];
    if (levelProvider.levels != null) {
      levelProvider.levels.forEach((level) => tabs.add(new Tab(
            text: level.name,
          )));
    }
    return new NFilterTabBar(tabs: tabs, controller: controller);
  }

  @override
  bool shouldRebuild(_UserPageHeaderDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        collapsedHeight != oldDelegate.collapsedHeight;
  }
}
