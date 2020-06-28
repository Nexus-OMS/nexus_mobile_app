import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/organization_bloc/organization_bloc.dart';
import 'package:nexus_mobile_app/ui/components/SearchButton.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/MemberPage.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/PositionPage.dart';

class OrganizationPage extends StatefulWidget {
  @override
  _OrganizationPageState createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationBloc, OrganizationState>(
        builder: (context, state) {
      if (state is OrganizationStateUninitialized)
        context
            .bloc<OrganizationBloc>()
            .add(OrganizationEventRefresh(Completer()));
      return RefreshIndicator(
          onRefresh: () {
            Completer completer = new Completer();
            context
                .bloc<OrganizationBloc>()
                .add(OrganizationEventRefresh(completer));
            return completer.future;
          },
          child: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 100.0,
              actions: <Widget>[
                SearchButton(),
              ],
              elevation: 0,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Organization',
                  style: TextStyle(color: Colors.black),
                ),
                collapseMode: CollapseMode.parallax,
              ),
            ),
            buildList(state)
          ]));
    });
  }

  Container _buildLevelsRow(OrganizationStateHasData state) {
    if (state.levels != null) {
      return Container(
        height: 100.0,
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
      return Container(child: Text("loading"));
    }
  }

  Container _buildPositionsRow(OrganizationStateHasData state) {
    if (state.positions != null) {
      return Container(
        padding: EdgeInsets.all(24.0),
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
      return Container(child: Text("loading"));
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
                  Text('No Organizations',
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
      return Text("loading");
    }, childCount: 1));
  }
}
