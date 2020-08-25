import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/organization_bloc/organization_bloc.dart';
import 'package:nexus_mobile_app/bloc/repositories/organization_repository.dart';
import 'package:nexus_mobile_app/bloc/users_bloc/users_bloc.dart';
import 'package:nexus_mobile_app/ui/components/SearchButton.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NErrorTile.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/MemberList.dart';

class MemberPage extends StatefulWidget {
  String title;
  String query;
  MemberPage(this.title, this.query);
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  @override
  Widget build(BuildContext context) {
    OrganizationRepository rep =
        BlocProvider.of<OrganizationBloc>(context).repository;
    return BlocProvider(
        create: (BuildContext context) => UsersBloc(rep),
        child: Scaffold(
            body: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
          if (state is UsersStateUninitialized)
            context
                .bloc<UsersBloc>()
                .add(UsersEventRefresh(Completer(), widget.query));
          if (state is UsersStateHasData) {
            if (state is UsersStateLoading) {
              if (state.users != null && state.users.length == 0) {
                return NErrorTile(error_name: 'users');
              }
              return Center(child: CircularProgressIndicator());
            }
            return RefreshIndicator(
                onRefresh: () {
                  Completer completer = new Completer();
                  context
                      .bloc<UsersBloc>()
                      .add(UsersEventRefresh(completer, widget.query));
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
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        widget.title,
                      ),
                      collapseMode: CollapseMode.parallax,
                    ),
                  ),
                  MemberList(state.users)
                ]));
          }
          return NErrorTile(
            error_name: 'users',
          );
        })));
  }
}
