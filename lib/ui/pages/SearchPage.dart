import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/ui/theme.dart';

class SearchPage extends StatefulWidget {
  Type type;
  SearchPage(this.type);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchFieldController = new TextEditingController();
  bool hasText = false;

  @override
  Widget build(BuildContext context) {
    searchFieldController.addListener(() {
      setState(() {
        if (searchFieldController.text != '') {
          hasText = true;
        }
      });
    });

    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        titleSpacing: 8.0,
        elevation: 0.0,
        title: new Theme(
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
                  Icons.arrow_back,
                  color: Colors.grey,
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
      body: new Center(child: new Text('List Here')),
    );
  }
}
