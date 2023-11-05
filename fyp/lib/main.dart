import 'package:flutter/material.dart';
import 'package:fyp/BarCode.dart';
import 'package:fyp/ImageToText.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TextRecognitionExample(),
    );
  }
}
