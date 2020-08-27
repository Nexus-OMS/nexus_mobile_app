import 'dart:ui';

import 'package:flutter/material.dart';

class SafeAreaHeader {
  static Widget sliver() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SafeHeaderDelegate(),
    );
  }
}

class _SafeHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SafeArea(child: Container());
  }

  @override
  double get maxExtent => window.viewPadding.top;

  @override
  double get minExtent => window.viewPadding.top;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
