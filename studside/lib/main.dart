import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'pages/mainpage.dart';
import 'models/mainmodel.dart';
import 'pages/qrscannerpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final MainModel _model = MainModel();

  @override
  Widget build(BuildContext context) {
    _model.autoLogin();
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.orange,
        ),
        home: MyAppExtender(),
      ),
    );
  }
}

class MyAppExtender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return (model.getHostelName != null && model.getRoomNo != null)
            ? MainPage(model)
            : ScanScreen();
      },
    );
  }
}
