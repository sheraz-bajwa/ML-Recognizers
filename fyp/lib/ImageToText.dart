import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

class TextRecognitionExample extends StatefulWidget {
  @override
  _TextRecognitionExampleState createState() => _TextRecognitionExampleState();
}

class _TextRecognitionExampleState extends State<TextRecognitionExample> {
  String scannedText = '';
  bool isTextScanning = false;
  File? selectedImage; // Store the selected image file.

  Future<void> pickAndRecognizeText() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      await recognizeText(imageFile);
    }
  }

  Future<void> recognizeText(File imageFile) async {
    setState(() {
      isTextScanning = true;
    });

    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    scannedText = '';

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText += line.text + '\n';
      }
    }

    await textRecognizer.close();

    setState(() {
      isTextScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (selectedImage != null)
              Image.file(selectedImage!, width: 200, height: 200)
            else
              Container(
                height: 200,
                width: 200,
                color: Colors.grey,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickAndRecognizeText,
              child: Text('Pick Image and Recognize Text'),
            ),
            if (scannedText.isNotEmpty)
              Text(scannedText)
            else
              Text('No text scanned'),
          ],
        ),
      ),
    );
  }
}
