import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/bloc/repositories/search_repository.dart';
import 'package:nexus_mobile_app/enum/SearchTypes.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/services/AuthorizedClient.dart';
import 'package:nexus_mobile_app/ui/components/tiles/MemberTile.dart';
import 'package:nexus_mobile_app/ui/components/tiles/UpdateTile.dart';
import 'package:nexus_mobile_app/utils/debouncer.dart';

import '../../theme.dart';

class SearchPage extends StatefulWidget {
  final List<SearchTypes> filters;
  AuthorizedClient client;

  SearchPage(this.client, {this.filters});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchRepository repository;
  TextEditingController _textFieldController;
  final Debouncer onSearchDebouncer =
      Debouncer(delay: Duration(milliseconds: 500));
  FocusNode _focusNode;
  TextStyle inputTextStyle;
  TextStyle hintTextStyle;
  var hasText = false;

  @override
  void initState() {
    super.initState();
    repository = SearchRepository(widget.client);
    _textFieldController = TextEditingController();
    _textFieldController.addListener(() {
      onSearchDebouncer.debounce(() {
        if (_textFieldController.text.length >= 2) {
          repository.search(_textFieldController.text, types: widget.filters);
        }
      });
    });
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        pinned: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 32),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: TextFormField(
          controller: _textFieldController,
          focusNode: _focusNode,
          style: inputTextStyle,
          onChanged: (text) {
            if (text == '') {
              setState(() {
                hasText = false;
              });
            }
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              suffixIcon: hasText && _focusNode.hasFocus
                  ? IconButton(
                      icon:
                          Icon(Icons.clear, color: NexusTheme.textLightMedium),
                      onPressed: () => setState(() {
                            _textFieldController.text = '';
                            hasText = false;
                          }))
                  : null,
              hintText: 'Search',
              filled: false,
              hintStyle: hintTextStyle,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none),
          autofocus: false,
        ),
      ),
      SliverList(
        delegate: SliverChildListDelegate(buildResults()),
      )
    ]));
  }

  List<Widget> buildResults() {
    var sections = <Widget>[];
    if (widget.filters != null) {
      for (var type in widget.filters) {
        switch (type) {
          case SearchTypes.users:
            sections.add(getUsers(context));
            break;
          case SearchTypes.updates:
            sections.add(getUpdates(context));
            break;
          default:
        }
      }
      return sections;
    }
    // If filters null return all
    return [getUsers(context), getUpdates(context)];
  }

  Widget getUsers(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: repository.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: Text('Start typing to search...')),
            ],
          );
        } else if (snapshot.data is List<User>) {
          if (snapshot.data.isEmpty) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Text(
                'No Results Found.',
              ),
            );
          }
          var results = snapshot.data;
          return Column(
            children: results.map((user) {
              return MemberTile(
                user: user,
                onPressed: (_user) {
                  Navigator.of(context).pop(_user);
                },
              );
            }).toList(),
          );
        }
        return Container();
      },
    );
  }

  Widget getUpdates(BuildContext context) {
    return StreamBuilder<List<Update>>(
      stream: repository.updateStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: Text('Start typing to search...')),
            ],
          );
        } else if (snapshot.data is List<Update>) {
          if (snapshot.data.isEmpty) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: Text(
                'No Results Found.',
              ),
            );
          }
          var results = snapshot.data;
          return Column(
            children: results.map((update) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: UpdateTile(
                      update: update,
                      onPressed: (_update) {
                        Navigator.of(context).pop(_update);
                      }));
            }).toList(),
          );
        }
        return Container();
      },
    );
  }
}
