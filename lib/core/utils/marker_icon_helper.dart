import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIconHelper {
  static Future<BitmapDescriptor> fromIcon({
    required IconData icon,
    required Color color,
    double size = 80,
    Color backgroundColor = Colors.white,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final paint = Paint()..color = backgroundColor;

    // Draw circle background
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size * 0.6,
        fontFamily: icon.fontFamily,
        color: color,
        package: icon.fontPackage,
      ),
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());

    final byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }
}