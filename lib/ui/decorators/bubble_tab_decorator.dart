import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class BubbleTabDecorator extends Decoration {
  final Color highlight;
  BubbleTabDecorator(this.highlight);
  @override
  _CustomPainter createBoxPainter([VoidCallback onChanged]) {
    return _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final BubbleTabDecorator decoration;
  final double indicatorHeight = 40.0;

  _CustomPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    final rect = Offset(offset.dx + 8,
            (configuration.size.height / 2) - (indicatorHeight - 4) / 2) &
        Size(configuration.size.width - 16, indicatorHeight - 8);

    final paint = Paint();
    paint.color = decoration.highlight;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(14.0)), paint);
  }
}
