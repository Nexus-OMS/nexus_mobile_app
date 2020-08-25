import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/ui/pages/search/search_page.dart';
import 'package:nexus_mobile_app/ui/theme.dart';

class SearchButton<T> extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchButtonState<T>();
}

class _SearchButtonState<T> extends State<SearchButton>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  double _fraction = 0.0;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SearchButtonPainter(_fraction, MediaQuery.of(context).size),
      child: new IconButton(icon: Icon(Icons.search), onPressed: reveal),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    //_controller.dispose();
    super.dispose();
  }

  Future reveal() async {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      });

    _controller.forward();
    await Navigator.push(context, new SearchRoute(widget: SearchPage()));
    _controller.reverse();
  }
}

class SearchButtonPainter extends CustomPainter {
  double _fraction = 0.0;
  Size _screenSize;

  SearchButtonPainter(this._fraction, this._screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var finalRadius =
        sqrt(pow(_screenSize.width / 2, 2) + pow(_screenSize.height / 2, 2));
    var radius = finalRadius * _fraction;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    var greyPaint = Paint()
      ..color = NexusTheme.lightGrey
      ..style = PaintingStyle.fill;
    //canvas.drawRect(Rect.fromCenter(center: Offset(40, 28), width: 40, height: 40), greyPaint);
    //canvas.drawCircle(Offset(20, 28), 20, greyPaint);
  }

  @override
  bool shouldRepaint(SearchButtonPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}

class SearchRoute extends PageRouteBuilder {
  final Widget widget;
  SearchRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new FadeTransition(opacity: animation, child: child);
          /*
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
        */
        });
}
