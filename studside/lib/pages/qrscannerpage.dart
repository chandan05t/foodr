import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/mainmodel.dart';
import 'mainpage.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String qrcode;
  bool gotvalue = true;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('QR Code Scanner'),
      ),
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Center(
            child: Column(
              children: <Widget>[
                Text('Scan the QR code from Vendor to Login'),
                Container(
                  height: 300.0,
                  width: 300.0,
                  child: QrCamera(
                    fit: BoxFit.cover,
                    qrCodeCallback: (value) {
                      qrcode = value;
                      String trimmedValue =
                          value.substring(1, value.length - 1);
                      List<String> loginValues = trimmedValue.split(', ');
                      model
                          .loginProcess(
                              loginValues[0], loginValues[2], loginValues[1])
                          .then(
                        (bool onValue) {
                          if (onValue && gotvalue) {
                            gotvalue = false;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage(model)));
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
