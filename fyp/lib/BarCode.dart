import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

class Barcode1 extends StatefulWidget {
  @override
  _Barcode1State createState() => _Barcode1State();
}

class _Barcode1State extends State<Barcode1> {
  String scannedBarcode = '';
  bool isScanning = false;
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
    final barcodeScanner = GoogleMlKit.vision.barcodeScanner();

    setState(() {
      isScanning = true;
    });
    try {
      final inputImage =
          InputImage.fromFile(imageFile); // Use the imageFile parameter.
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        scannedBarcode = barcodes[0]
            .value
            .toString(); // Assuming you only want the first barcode found.
      } else {
        scannedBarcode = 'No barcode found';
      }
    } catch (e) {
      scannedBarcode = 'Error: $e';
    }

    await barcodeScanner.close();

    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BarCode Scanner Example'),
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
            if (scannedBarcode.isNotEmpty)
              Text(scannedBarcode)
            else
              Text('No text scanned'),
          ],
        ),
      ),
    );
  }
}
