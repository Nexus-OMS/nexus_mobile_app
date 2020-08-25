import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/ui/decorators/BubbleTabDecorator.dart';

class NFilterTabBar extends StatelessWidget {
  NFilterTabBar({
    @required this.tabs,
    @required this.controller,
  });

  List<Tab> tabs;
  TabController controller;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: new TabBar(
        tabs: tabs,
        isScrollable: true,
        indicator: new BubbleTabDecorator(),
        controller: controller,
      ),
    );
  }
}
