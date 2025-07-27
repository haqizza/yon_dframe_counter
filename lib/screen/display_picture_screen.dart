import 'dart:convert';
// import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;

import 'package:yon_dframe_counter/utils/api_service.dart';
import 'package:yon_dframe_counter/utils/prediction_class.dart';


class DisplayPictureScreen extends StatefulWidget {
  final XFile image;

  const DisplayPictureScreen({super.key, required this.image});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late Future<Widget> _imageProcessingFuture;

  @override
  void initState() {
    super.initState();
    // Start the processing once when the widget is initialized.
    _imageProcessingFuture = _processImage();
  }

  Widget _displayResult(img.Image image, Outputs data) {
    List<Predictions>? detectedObjects = data.predictionData!.predictions!.predictions;
    
    Map<String, int> classCount = <String, int>{};

    for (int i = 0; i < detectedObjects!.length; i++) {
      String className = detectedObjects[i].className.toString();

      if(classCount[className] == null) {
        classCount[className] = 1;
      }
      else {
        classCount[className] = classCount[className]! + 1;
      }
    }
    img.Image annotatedImage = image;

    for (var i = 0; i < detectedObjects.length; i++) {
      Predictions object = detectedObjects[i];

      double halfWidth = object.width! / 2;
      double halfHeight = object.height! / 2;

      int x1 = (object.x! - halfWidth).toInt();
      int x2 = (object.x! + halfWidth).toInt();
      int y1 = (object.y! - halfHeight).toInt();
      int y2 = (object.y! + halfHeight).toInt();

      annotatedImage = img.drawRect(
        annotatedImage,
        x1: x1,
        y1: y1,
        x2: x2,
        y2: y2,
        color: img.ColorRgb8(255, 0, 0)
      );
    }

    Uint8List imageBytes = Uint8List.fromList(img.encodeJpg(annotatedImage));

    return Column(
      children: [
        Image.memory(imageBytes),
        SizedBox(height: 10.0),
        ...classCount.entries.map((item) => Text('${item.key}: ${item.value}'))
      ],
    );
  }

  Future<Widget> _processImage() async {
    try {
      final Uint8List imageFile = await widget.image.readAsBytes();
      final String base64Image = base64Encode(imageFile);

      final String body = json.encode({
        'api_key': dotenv.env['API_CODE'],
        'inputs': {
          "image": {"type": "base64", "value": base64Image}
        }
      });

      final http.Response response = await APIService.sendImage(body: body);
      print(response.body);
      final dynamic data = Outputs.fromJson(json.decode(response.body));

      img.Image? image = await img.decodeImageFile(widget.image.path);

      return _displayResult(image as img.Image, data);
    } catch (e, stack) {
      print(stack);
      // Propagate the error to be caught by the FutureBuilder.
      throw Exception('Failed to process image.: $e, $stack');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
        child: FutureBuilder<Widget>(
          future: _imageProcessingFuture,
          builder: (context, snapshot) {
            // Check the state of the future
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the result, show a loading indicator.
              return const Padding(
                padding: EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 10),
                    Text("Processing..."),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              // If an error occurred, display an error message.
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              // When the data is available, display the count.
              return snapshot.data!;
            } else {
              // Default state
              return const Text("Starting processing...");
            }
          },
        ),
      ),
    );
  }
}