import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/bloc/update_bloc/update_bloc.dart';
import 'package:nexus_mobile_app/enum/SearchTypes.dart';
import 'package:nexus_mobile_app/models/models.dart';
import 'package:nexus_mobile_app/ui/components/tiles/SkeletonTile.dart';
import 'package:nexus_mobile_app/ui/components/tiles/UpdateTile.dart';
import 'package:nexus_mobile_app/ui/pages/search/search_bar.dart';

class UpdatePage extends StatelessWidget {
  final Update update;

  UpdatePage(this.update);

  @override
  Widget build(BuildContext context) {
    var text = update.update_text;
    return Scaffold(
        body: SafeArea(
            child: ListView(shrinkWrap: true, children: <Widget>[
      Row(children: [
        Padding(
            padding: EdgeInsets.only(left: 14.0, bottom: 14.0),
            child: IconButton(
                icon: Icon(Icons.chevron_left, size: 36.0),
                onPressed: () => Navigator.of(context).pop()))
      ]),
      Padding(
          padding: EdgeInsets.only(left: 36.0, right: 36.0),
          child: Theme(
              data: Theme.of(context).copyWith(
                  textTheme:
                      Theme.of(context).textTheme.apply(fontSizeFactor: 2.0)),
              child: HtmlWidget(
                text,
                tableCellPadding: EdgeInsets.all(0),
              ))),
    ])));
  }
}

class UpdatesPage extends StatefulWidget {
  @override
  _UpdatesPageState createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<UpdateBloc, UpdateState>(builder: (context, state) {
      if (state is UpdateStateUninitialized) {
        context.bloc<UpdateBloc>().add(UpdateEventPage());
      }
      return SafeArea(
          child: RefreshIndicator(
              onRefresh: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationEventRefresh());
                var completer = Completer();
                context.bloc<UpdateBloc>().add(UpdateEventRefresh(completer));
                return completer.future;
              },
              child: CustomScrollView(slivers: <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SearchBarHeaderDelegate(),
                ),
                buildList(state)
              ])));
    });
  }

  Widget buildList(UpdateState state) {
    if (state is UpdateStateNoData) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No Updates',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                  Text('Pull to Refresh',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                ],
              ),
            );
          },
          childCount: 1,
        ),
      );
    } else if (state is UpdateStateHasData) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: UpdateTile(update: state.updates[index]),
          );
        }, childCount: state.updates.length),
      );
    }
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return SkeletonTile(
        height: 64,
      );
    }, childCount: 10));
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
          searchTypes: [SearchTypes.updates],
          floating: true,
          searchReturn: (update) {
            if (update is Update) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UpdatePage(update)));
            }
          },
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
