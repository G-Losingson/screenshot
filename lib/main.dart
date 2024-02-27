import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gallery_saver/gallery_saver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScreenShot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    dynamic year = DateTime.now().year;
    dynamic month = DateTime.now().month;
    dynamic day = DateTime.now().day;
    dynamic hour = DateTime.now().hour;
    dynamic minute = DateTime.now().minute;
    dynamic second = DateTime.now().second;
    dynamic millisecond = DateTime.now().millisecond;
    return Scaffold(
      body: const BodyView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final directory = (await getApplicationDocumentsDirectory()).path;
          dynamic imageName = '$year$month$day$hour$minute$second$millisecond';
          final image = await screenshotController.captureFromWidget(
            const BodyView(),
            pixelRatio: pixelRatio,
            delay: const Duration(milliseconds: 10),
          );
          final imagePath = await File('$directory/$imageName.png').create();
          await imagePath.writeAsBytes(image);
          final result = await Share.shareXFiles(
            [XFile(imagePath.path)],
            text: 'A screenshot like ie',
            subject: 'Exemple',
          );
          if (result.status == ShareResultStatus.success) {
            GallerySaver.saveImage(imagePath.path).then(
              (value) => debugPrint('Image $imageName Saved '),
            );
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.blue.shade400,
                content: const Text('Thx u for sharing the picture'),
              ),
            );
          } else if (result.status == ShareResultStatus.dismissed) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.blue.shade400,
                content: const Text("U don't like the picture ?"),
              ),
            );
          }
        },
        child: const Icon(
          CupertinoIcons.arrowshape_turn_up_right_fill,
          color: Colors.blue,
          size: 20,
        ),
      ),
    );
  }

  void saveNetworkImage() async {
    String path = 'https://avatars.githubusercontent.com/u/127692851?v=4.png';
    GallerySaver.saveImage(path).then((success) {
      debugPrint('Image is saved');
    });
  }
}

class BodyView extends StatelessWidget {
  const BodyView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            color: Colors.blue,
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.only(bottom: 250),
            child: Text(
              'ScreenShot Demo',
              style: TextStyle(
                color: Colors.blue.shade100,
                fontSize: 25,
                height: 3,
              ),
            ),
          ),
          const FlutterLogo(size: 100),
          const Text(
            'Tap on the bottom buttom to share this screen',
            style: TextStyle(
              color: Colors.blue,
              height: 3,
            ),
          ),
        ],
      ),
    );
  }
}
