import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // PlatformExceptionで必要

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Reader Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Barcode Reader Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _barcode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                color: Colors.blueAccent,
                child: Text(
                  'SCAN',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  barCodeScan();
                }),
            const SizedBox(height: 24.0),
            Text('バーコード: $_barcode'),
          ],
        ),
      ),
    );
  }

  /// バーコードスキャン開始、結果取得
  Future<void> barCodeScan() async {
    try {
      var code = await BarcodeScanner.scan();
      setState(() {
        _barcode = code;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => _barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => _barcode =
          'User returned using the "back"-button before scanning anything');
    } on Exception catch (e) {
      setState(() => _barcode = 'Unknown error: $e');
    }
  }
}
