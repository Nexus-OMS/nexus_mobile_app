import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/bloc/repositories/search_repository.dart';
import 'package:nexus_mobile_app/enum/SearchTypes.dart';
import 'package:nexus_mobile_app/models/model.dart';
import 'package:nexus_mobile_app/ui/components/tiles/MemberTile.dart';

import '../../theme.dart';

class SearchPage extends StatefulWidget {
  final List<SearchTypes> filters;

  SearchPage({this.filters});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textFieldController;
  FocusNode _focusNode;
  TextStyle inputTextStyle;
  TextStyle hintTextStyle;
  List<Widget> results;
  var hasText = false;

  @override
  void initState() {
    super.initState();
    results = List();
    _textFieldController = TextEditingController();
    _textFieldController.addListener(() {
      if (_textFieldController.text.length >= 3) {
        setState(() {
          results = buildResults(_textFieldController.text);
        });
      }
    });
    _focusNode = FocusNode();
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
        delegate: SliverChildListDelegate(results),
      )
    ]));
  }

  List<Widget> buildResults(String query) {
    if (query.length < 3) {
      return [Container()];
    }
    // List of widget sections (trips, places, friends)
    List<Widget> sections = List();
    if (widget.filters != null) {
      for (var type in widget.filters) {
        switch (type) {
          case SearchTypes.users:
            sections.add(getUsers(context, query));
            break;
          default:
        }
      }
      return sections;
    }
    // If filters null return all
    return [getUsers(context, query)];
  }
}

Widget getUsers(BuildContext context, String query) {
  return StreamBuilder(
    stream: SearchRepository.search(query, types: [SearchTypes.users]),
    builder: (context, AsyncSnapshot<List<Model>> snapshot) {
      if (!snapshot.hasData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: CircularProgressIndicator()),
          ],
        );
      } else if (snapshot.data.isEmpty) {
        return Column(
          children: <Widget>[
            Text(
              "No Results Found.",
            ),
          ],
        );
      } else {
        var results = snapshot.data;
        return Column(
          children: results.map((user) {
            return MemberTile(user: user);
          }).toList(),
        );
      }
    },
  );
}
