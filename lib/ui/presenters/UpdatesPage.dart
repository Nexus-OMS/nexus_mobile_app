import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/ui/components/NSearchIconButton.dart';
import 'package:nexus_mobile_app/ui/components/NSliverIconButton.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NUpdateTile.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class UpdatePage extends StatelessWidget {
  final Update update;

  UpdatePage(this.update);

  @override
  Widget build(BuildContext context) {
    String text = update.update_text;
    return new Scaffold(
      appBar: AppBar(
        title: new Text(update.update_title),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new ListView(
          children: <Widget>[new Text(text)],
        ),
      ),
    );
  }
}

class UpdatesPage extends StatelessWidget {
  Widget _buildBody(List<Update> updates, context) {
    Widget child;
    if (updates == null) {
      child = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      List<Widget> children;
      if (updates.length == 0) {
        children = [
          new Padding(
            padding: new EdgeInsets.all(16.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('No Updates',
                    style: new TextStyle(fontSize: 16.0, color: Colors.grey)),
                new Text('Pull to Refresh',
                    style: new TextStyle(fontSize: 12.0, color: Colors.grey)),
              ],
            ),
          )
        ];
      } else {
        children = new List();
        updates.forEach((update) {
          children.add(new NUpdateTile(update: update));
        });
      }
      child = new ListView(
        children: children,
      );
    }
    return new RefreshIndicator(
      onRefresh: () {},
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        onRefresh: () {},
        child: new CustomScrollView(slivers: <Widget>[
          new SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 100.0,
            actions: <Widget>[
              new NSearchIconButton(),
            ],
            elevation: 0,
            leading: new NSliverIconButton(
                onPressed: null, icon: Icon(OMIcons.menu)),
            backgroundColor: Colors.white,
            flexibleSpace: new FlexibleSpaceBar(
              title: Text(
                'Updates',
                style: TextStyle(color: Colors.black),
              ),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          new SliverList(
            delegate: new SliverChildBuilderDelegate((context, index) {
              return new Padding(
                padding: new EdgeInsets.all(16.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('No Updates',
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.grey)),
                    new Text('Pull to Refresh',
                        style:
                            new TextStyle(fontSize: 12.0, color: Colors.grey)),
                  ],
                ),
              );
            }),
          )
        ]));
  }
}
