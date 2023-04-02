// Login Button
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget FButton(String titile, Color color, Function() pressed) {
  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
      onPressed: pressed,
      child: Text(titile),
    ),
  );
}
