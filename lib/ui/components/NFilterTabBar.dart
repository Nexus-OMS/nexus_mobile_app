import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/ui/decorators/BubbleTabDecorator.dart';

class NFilterTabBar extends StatelessWidget {
  NFilterTabBar({
    @required this.tabs,
    @required this.controller,
  });

  final List<Tab> tabs;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: TabBar(
        tabs: tabs,
        isScrollable: true,
        indicator: BubbleTabDecorator(),
        controller: controller,
      ),
    );
  }
}
