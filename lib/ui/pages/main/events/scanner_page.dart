import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:nexus_mobile_app/bloc/repositories/event_repository.dart';
import 'package:nexus_mobile_app/models/Event.dart';
import 'package:nexus_mobile_app/ui/components/tiles/MemberTile.dart';
import 'package:nexus_mobile_app/extensions.dart';
import 'package:nexus_mobile_app/ui/theme.dart';

class ScannerPage extends StatefulWidget {
  final Function onScan;
  final Event event;
  ScannerPage(this.onScan, this.event);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final BarcodeDetector barcodeDetector = FirebaseVision.instance
      .barcodeDetector(
          BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.all));
  List<CameraDescription> cameras;
  List<Offset> _box;
  CameraController controller;
  final GlobalKey _canvasKey = GlobalKey();
  Set<String> detections = {};
  EventRepository repository;

  @override
  void initState() {
    super.initState();
    repository = EventRepository(context.client);
    _initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
    barcodeDetector.close();
  }

  void _initCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.high);
      await controller.initialize();
      setState(() {});
      await controller.startImageStream((image) async {
        final metadata = FirebaseVisionImageMetadata(
            rawFormat: image.format.raw,
            size: Size(image.width.toDouble(), image.height.toDouble()),
            planeData: image.planes
                .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
                    bytesPerRow: currentPlane.bytesPerRow,
                    height: currentPlane.height,
                    width: currentPlane.width))
                .toList(),
            rotation: ImageRotation.rotation90);

        final visionImage =
            FirebaseVisionImage.fromBytes(image.planes[0].bytes, metadata);
        var x = image.width.toDouble();
        var y = image.height.toDouble();
        if (mounted && barcodeDetector != null) {
          var uid =
              _extract(await barcodeDetector.detectInImage(visionImage), y, x);
          if (uid != null) {
            _addAttendance(uid);
          }
        }
      });
    }
  }

  Future<void> _addAttendance(String uid) async {
    Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: 'ID Found',
        duration: Duration(seconds: 1, milliseconds: 500),
        messageText: Builder(
          builder: (context) {
            return Row(
              children: [Text('Submitting UID'), CircularProgressIndicator()],
            );
          },
        ))
      ..show(context);
    await repository
        .saveAttendance(widget.event.id, user_uid: uid)
        .then((record) {
      if (record != null) {
        widget.onScan(record);
        Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            backgroundColor: NexusTheme.success,
            title: 'Attendance Saved',
            duration: Duration(seconds: 3),
            messageText: Builder(
              builder: (context) {
                return MemberTile(user: record.user);
              },
            ))
          ..show(context);
      } else {
        Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            backgroundColor: NexusTheme.danger,
            title: 'Error',
            duration: Duration(seconds: 3),
            messageText: Builder(
              builder: (context) {
                return Row(
                  children: [
                    Text('Unable to find user.'),
                  ],
                );
              },
            ))
          ..show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.close),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 48),
      ),
      body: Stack(children: [
        Center(
            child: controller != null
                ? CustomPaint(
                    foregroundPainter: GuidelinePainter(_box),
                    child: AspectRatio(
                        key: _canvasKey,
                        aspectRatio: controller.value.aspectRatio,
                        child: CameraPreview(controller)))
                : CircularProgressIndicator())
      ]),
    );
  }

  String _extract(List<Barcode> barcodes, double height, double width) {
    RenderBox box;
    if (mounted) {
      box = _canvasKey.currentContext.findRenderObject() as RenderBox;
    }
    for (var barcode in barcodes) {
      if (barcode.format.value < 0) return null;
      _box = barcode.cornerPoints;
      if (box != null) {
        for (var idx in [0, 1, 2, 3]) {
          _box[idx] = Offset((_box[idx].dx / width) * box.size.width,
              (_box[idx].dy / height) * box.size.height);
        }
      }
      if (mounted) setState(() {});
      if (!detections.contains(barcode.displayValue)) {
        print(barcode.displayValue);
        detections.add(barcode.displayValue);
        return barcode.displayValue;
      }
      // See API reference for complete list of supported types
      // switch (valueType) {
      //   case BarcodeValueType.wifi:
      //     final String ssid = barcode.wifi.ssid;
      //     final String password = barcode.wifi.password;
      //     final BarcodeWiFiEncryptionType type = barcode.wifi.encryptionType;
      //     break;
      //   case BarcodeValueType.url:
      //     final String title = barcode.url.title;
      //     final String url = barcode.url.url;
      //     break;
      // }
    }
    return null;
  }
}

class GuidelinePainter extends CustomPainter {
  final List<Offset> box;
  GuidelinePainter(this.box);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 3.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    var path = Path();
    if (box != null) {
      path.moveTo(box[0].dx, box[0].dy);
      path.lineTo(box[1].dx, box[1].dy);
      path.moveTo(box[1].dx, box[1].dy);
      path.lineTo(box[2].dx, box[2].dy);
    }
    //canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
