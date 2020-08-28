import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonTile extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets padding;
  SkeletonTile(
      {this.height = 30,
      this.width = double.infinity,
      this.padding = const EdgeInsets.all(12)});

  final EdgeInsets textInsets = EdgeInsets.only(top: 4, bottom: 4);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        child: Shimmer.fromColors(
          child: SizedBox(
            height: height,
            width: width,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withAlpha(75)),
            ),
          ),
          baseColor: Colors.grey.withAlpha(75),
          highlightColor: Colors.white10.withAlpha(75),
        ));
  }
}
