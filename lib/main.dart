import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:path_provider/path_provider.dart';

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter barcode'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Center(
              child: Container(
                  height: 550,
                  width: 320,
                  color: Colors.white,
                  child: RepaintBoundary(
                    key: globalKey,
                    child: SfBarcodeGenerator(
                      value: 'www.syncfusion.com',
                      showValue: true,
                    ),
                  ))),
          Container(
              child: ButtonTheme(
                  minWidth: 40.0,
                  height: 30.0,
                  child: RaisedButton(
                    onPressed: () {
                      renderImage();
                    },
                    child: Text('Export as image',
                        textScaleFactor: 1,
                        style: TextStyle(color: Colors.white)),
                  ))),
        ])));
  }

  Future<void> renderImage() async {
    return new Future.delayed(const Duration(milliseconds: 100), () async {
      final RenderRepaintBoundary boundary = globalKey.currentContext
          .findRenderObject(); //get the render object from context

      final ui.Image image = await boundary.toImage(); // Convert
      dynamic bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      bytes =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

      if (image != null) {
        final Directory documentDirectory =
            await getApplicationDocumentsDirectory();
        final String path = documentDirectory.path;
        final String imageName = 'barcode.png';
        imageCache.clear();
        File file = new File('$path/$imageName');
        file.writeAsBytesSync(bytes);

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Container(
                    color: Colors.white,
                    child: Image.file(file),
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }
}

