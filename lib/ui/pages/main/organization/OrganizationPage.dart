import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/organization_bloc/organization_bloc.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/services/APIRoutes.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/ui/components/PageLoadingIndicator.dart';
import 'package:nexus_mobile_app/ui/components/save_area_header.dart';
import 'package:nexus_mobile_app/ui/components/tiles/MemberTile.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NErrorTile.dart';
import 'package:nexus_mobile_app/ui/components/tiles/SkeletonTile.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/MemberPage.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/PositionPage.dart';
import 'package:nexus_mobile_app/ui/pages/search/search_bar.dart';

class OrganizationPage extends StatefulWidget {
  @override
  _OrganizationPageState createState() => _OrganizationPageState();
}

enum _UsersState { uninitialized, loading, error, hasData }

class _OrganizationPageState extends State<OrganizationPage>
    with AutomaticKeepAliveClientMixin {
  _UsersState _usersState = _UsersState.uninitialized;
  List<User> users = List();

  @override
  void initState() {
    getUsers();
  }

  Future<void> getUsers() async {
    if (mounted) {
      setState(() {
        _usersState = _UsersState.loading;
        users = List();
      });
    }
    var raw = await AuthorizedClient.get(route: APIRoutes.routes[User]);
    if (mounted) {
      setState(() {
        for (var item in raw) {
          users.add(User.fromMap(item));
        }
        _usersState = _UsersState.hasData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationBloc, OrganizationState>(
        builder: (context, state) {
      if (state is OrganizationStateUninitialized)
        context
            .bloc<OrganizationBloc>()
            .add(OrganizationEventRefresh(Completer()));
      return SafeArea(
          child: RefreshIndicator(
              onRefresh: () {
                Completer completer = new Completer();
                context
                    .bloc<OrganizationBloc>()
                    .add(OrganizationEventRefresh(completer));
                getUsers();
                return completer.future;
              },
              child: CustomScrollView(slivers: <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SearchBarHeaderDelegate(),
                ),
                buildList(state),
                buildUsersList(state)
              ])));
    });
  }

  Widget _buildLevelsRow(OrganizationStateHasData state) {
    if (state.levels != null && state.levels.length != 0) {
      return Container(
        height: 80.0,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: state.levels.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: ActionChip(
                  label: Text(state.levels[index].name),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MemberPage(
                            state.levels[index].name,
                            'level=${state.levels[index].id}')));
                  },
                ));
          },
        ),
      );
    } else {
      return SkeletonTile(
        height: 30,
        width: double.infinity,
        padding: EdgeInsets.all(16),
      );
    }
  }

  Widget _buildPositionsRow(OrganizationStateHasData state) {
    if (state.positions != null) {
      return Container(
        padding: EdgeInsets.only(right: 24.0, bottom: 12, left: 24.0),
        child: OutlineButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0)),
          padding: EdgeInsets.all(8.0),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PositionPage(state.positions)));
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Text("Organization Chart",
                style: Theme.of(context).textTheme.button.copyWith(
                      fontWeight: FontWeight.w800,
                    )),
          ),
        ),
      );
    } else {
      return SkeletonTile(
        padding: EdgeInsets.only(right: 24.0, bottom: 12, left: 24.0),
        height: 50,
        width: double.infinity,
      );
    }
  }

  Widget buildUsersList(OrganizationState state) {
    switch (_usersState) {
      case _UsersState.error:
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return NErrorTile(
            error_name: 'users',
          );
        }, childCount: 1));
        break;
      case _UsersState.hasData:
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return MemberTile(user: users[index]);
        }, childCount: users.length));
        break;
      default:
        return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return SkeletonTile(height: 54);
        }, childCount: 12));
    }
  }

  Widget buildList(OrganizationState state) {
    if (state is OrganizationStateNoData) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No Data',
                      style: new TextStyle(fontSize: 16.0, color: Colors.grey)),
                  Text('Pull to Refresh',
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey)),
                ],
              ),
            );
          },
          childCount: 1,
        ),
      );
    } else if (state is OrganizationStateHasData) {
      return SliverList(
          delegate: SliverChildListDelegate(
              [_buildLevelsRow(state), _buildPositionsRow(state)]));
    }
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return PageLoadingIndicator();
    }, childCount: 1));
  }

  @override
  bool get wantKeepAlive => true;
}

class _SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SearchBar(
          floating: true,
          searchReturn: () {},
        )
      ],
    );
  }

  @override
  double get maxExtent => 160;

  @override
  double get minExtent => 86;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
