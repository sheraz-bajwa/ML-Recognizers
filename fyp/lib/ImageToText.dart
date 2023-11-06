import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';
import 'package:flutter_animated_button/flutter_animated_button.dart';

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
      setState(() {
        selectedImage = imageFile;
      });
      await recognizeText(imageFile);
    }
  }

  Future<void> CameraToRecognizeText() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      setState(() {
        selectedImage = imageFile;
      });
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
        title: Text(
          'Text RecogniZer',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: 50),

              if (selectedImage != null)
                Column(
                  children: [
                    Image.file(
                      selectedImage!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    Divider(),
                  ],
                )
              else
                Container(
                  height: 300,
                  width: 300,
                  color: Colors.grey,
                  child: Center(
                      child: Text(
                    "No Image is Selected",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              // SizedBox(height: 30),
              // ElevatedButton(
              //   onPressed: pickAndRecognizeText,
              //   child: Text('Pick Image and Recognize Text'),
              // ),

              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedButton(
                    height: 50,
                    width: 150,
                    text: 'Camera',
                    isReverse: true,
                    selectedText: 'Selected',
                    selectedTextColor: Colors.white,
                    transitionType: TransitionType.CENTER_LR_IN,
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    animatedOn: AnimatedOn.onTap,
                    selectedGradientColor: LinearGradient(
                        colors: [Colors.deepOrangeAccent, Colors.amber]),
                    backgroundColor: Colors.deepOrangeAccent,
                    borderColor: Colors.white,
                    selectedBackgroundColor: Colors.deepOrangeAccent,
                    borderRadius: 20,
                    borderWidth: 2,
                    onPress: CameraToRecognizeText,
                  ),
                  AnimatedButton(
                    height: 50,
                    width: 150,
                    text: 'Gallery',
                    isReverse: true,
                    selectedText: 'Selected',
                    selectedTextColor: Colors.white,
                    transitionType: TransitionType.CENTER_LR_IN,
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                    animatedOn: AnimatedOn.onTap,
                    selectedGradientColor: LinearGradient(
                        colors: [Colors.deepOrangeAccent, Colors.amber]),
                    backgroundColor: Colors.deepOrangeAccent,
                    borderColor: Colors.white,
                    selectedBackgroundColor: Colors.deepOrangeAccent,
                    borderRadius: 20,
                    borderWidth: 2,
                    onPress: pickAndRecognizeText,
                  ),
                ],
              ),
              SizedBox(height: 50),
              if (scannedText.isNotEmpty)
                Text(scannedText)
              else
                IntrinsicHeight(
                  child: IntrinsicWidth(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'No text scanned',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1),
                          ),
                        )),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
