import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/organization_bloc/organization_bloc.dart';
import 'package:nexus_mobile_app/models/Position.dart';
import 'package:nexus_mobile_app/models/User.dart';
import 'package:nexus_mobile_app/ui/pages/main/organization/MemberList.dart';

class PositionPage extends StatefulWidget {
  final Position position;
  PositionPage(this.position);
  @override
  _PositionPageState createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage> {
  List<User> members;
  @override
  Widget build(BuildContext context) {
    if (members == null) {
      BlocProvider.of<OrganizationBloc>(context)
          .repository
          .getUsersByPosition(widget.position.id)
          .then((value) {
        setState(() {
          members = value;
        });
      });
    }
    return Scaffold(
        body: SafeArea(
            child: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          pinned: true,
          floating: false,
          elevation: 0,
          title: Text(
            widget.position.name,
          )),
      MemberList(members),
      SliverList(
          delegate: SliverChildListDelegate(
        [
          Padding(
              padding: EdgeInsets.only(right: 8, left: 8), child: Divider()),
        ],
      )),
      _buildSubordinates(widget.position.children)
    ])));
  }

  Widget _buildSubordinates(List<Position> positions) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: OutlineButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0)),
                padding: EdgeInsets.all(8.0),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PositionPage(positions[index])));
                },
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    positions[index].name,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.chevron_right)
                              ])),
                    )
                  ],
                )),
          ),
        );
      },
      childCount: positions.length,
    ));
  }
}
