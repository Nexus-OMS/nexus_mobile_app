import 'package:nexus_mobile_app/extensions.dart';
import 'package:flutter/material.dart';

class ImageLoader extends StatefulWidget {
  final String route;
  final Widget placeholder;

  ImageLoader({Key key, @required this.route, this.placeholder})
      : super(key: key);
  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  Widget child;
  Widget placeholder;
  @override
  void initState() {
    super.initState();
    if (widget.placeholder == null) {
      placeholder = Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      placeholder = widget.placeholder;
    }
    asyncInit();
  }

  void asyncInit() async {
    child = await context.client.getImageWidget(widget.route, placeholder);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return child ?? widget.placeholder;
  }
}
