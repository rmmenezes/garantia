import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.060,
      fontWeight: FontWeight.bold,
    );

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.030,
    );

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 16, color: Colors.grey, height: 1.5);

TextStyle kHaveAnAccountStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: size.height * 0.022, color: Colors.black);

TextStyle kLoginOrSignUpTextStyle(
  Size size,
) =>
    GoogleFonts.ubuntu(
      fontSize: size.height * 0.022,
      fontWeight: FontWeight.w500,
      color: Colors.deepPurpleAccent,
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);

Uint8List convertToPng(Uint8List imageBytes) {
  const size = 300;
  final image = decodeImage(imageBytes)!;
  int x = (image.width - size) ~/ 2;
  int y = (image.height - size) ~/ 2;
  final croppedImage = copyCrop(image, x: x, y: y, width: size, height: size);
  PngEncoder pngEncoder = PngEncoder();
  Uint8List pngBytes = pngEncoder.encode(croppedImage);
  return pngBytes;
}

Future<PdfFont> loadOpenSansBoldFont() async {
  final fontData = await rootBundle.load("assets/OpenSans-Bold.ttf");
  return PdfTrueTypeFont(fontData.buffer.asUint8List(), 10);
}
