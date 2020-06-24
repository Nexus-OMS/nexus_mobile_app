import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/ui/components/tiles/NErrorTile.dart';

import '../SkeletonText.dart';

class SkeletonTile extends StatelessWidget {
  SkeletonTile();

  EdgeInsets textInsets = EdgeInsets.only(top: 4, bottom: 4);

  @override
  Widget build(BuildContext context) {
    try {
      return new GestureDetector(
          child: new Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: new Border(
                      bottom: BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ))),
              child: new Row(
                children: <Widget>[
                  new SkeletonText(width: 40, height: 40),
                  new Flexible(
                    child: new Padding(
                        padding: new EdgeInsets.only(left: 16.0, right: 16.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: textInsets,
                              child: new SkeletonText(width: 200, height: 12),
                            ),
                            new Padding(
                              padding: textInsets,
                              child: new SkeletonText(width: 150, height: 8),
                            ),
                            new Padding(
                              padding: textInsets,
                              child: new SkeletonText(width: 150, height: 8),
                            ),
                          ],
                        )),
                  )
                ],
              )),
          onTap: () {});
    } catch (e) {
      print(e);
      return new NErrorTile(error_name: 'user');
    }
  }
}
