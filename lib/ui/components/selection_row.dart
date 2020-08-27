import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/models/model.dart';
import 'package:nexus_mobile_app/ui/components/tiles/SkeletonTile.dart';

class SelectionRow extends StatefulWidget {
  final Function onSelect;
  final int defaultIndex;
  final List<Model> source;
  SelectionRow(this.onSelect, this.defaultIndex, this.source);
  @override
  _SelectionRowState createState() => _SelectionRowState();
}

class _SelectionRowState extends State<SelectionRow> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    var accent = Theme.of(context).accentColor;
    var chipColor = Theme.of(context).chipTheme.backgroundColor;
    if (widget.source != null) {
      return Container(
        height: 50.0,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.source.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: ActionChip(
                  backgroundColor: index == selected ? accent : chipColor,
                  label: Text(widget.source[index].name),
                  onPressed: () {
                    widget.onSelect(widget.source[index]);
                    setState(() {
                      selected = index;
                    });
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
}
