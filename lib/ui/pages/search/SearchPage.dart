import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/search_bloc/search_bloc.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NErrorTile.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/MemberList.dart';
import 'package:nexus_mobile_app/ui/theme.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchFieldController = new TextEditingController();
  Timer timer;
  bool hasText = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => SearchBloc(),
        child: Scaffold(body:
            BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
          if (state is SearchStateUninitialized) {
            searchFieldController.addListener(() {
              if (timer != null) timer.cancel();
              timer = Timer(const Duration(seconds: 1), () {
                if (searchFieldController.text != null &&
                    searchFieldController.text.length > 2)
                  context
                      .bloc<SearchBloc>()
                      .add(SearchEventRefresh(searchFieldController.text));
              });
              setState(() {
                if (searchFieldController.text != '') {
                  hasText = true;
                }
              });
            });
          }
          if (state is SearchStateHasData) {
            return CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                floating: false,
                expandedHeight: 100.0,
                elevation: 0,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: Theme(
                  data: new ThemeData(
                    highlightColor: Colors.transparent,
                    primaryColor: Colors.transparent,
                  ),
                  child: new TextFormField(
                    controller: searchFieldController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(2.0, 4.0, 2.0, 4.0),
                      suffixIcon: hasText
                          ? new IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey),
                              onPressed: () => setState(() {
                                    searchFieldController.text = '';
                                    hasText = false;
                                  }))
                          : null,
                      prefixIcon: new IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: Colors.grey,
                          size: 28.0,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      filled: true,
                      hintText: 'Search...',
                      fillColor: NexusTheme.lightGrey,
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: NexusTheme.lightGrey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: NexusTheme.lightGrey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    autofocus: true,
                  ),
                ),
              ),
              _buildResponses(state.users, state.updates)
            ]);
          } else {
            return NErrorTile(
              error_name: 'error',
            );
          }
        })));
  }

  Widget _buildResponses(users, updates) {
    if (users == null) {
      return SliverList(
          delegate: SliverChildListDelegate(
              [Center(child: Text("Not implemented."))]));
    }
    return MemberList(users);
  }
}
