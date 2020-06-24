import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/NColors.dart' as NColor;

class SkeletonText extends StatefulWidget {
  final double height;
  final double width;

  SkeletonText({Key key, this.height = 20, this.width = 200}) : super(key: key);

  createState() => SkeletonTextState();
}

class SkeletonTextState extends State<SkeletonText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(() {
        setState(() {});
      });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.height / 2)),
              gradient: LinearGradient(
                  begin: Alignment(gradientPosition.value, 0),
                  end: Alignment(-1, 0),
                  colors: [Colors.black12, Colors.black26, Colors.black12])),
        ));
  }
}
