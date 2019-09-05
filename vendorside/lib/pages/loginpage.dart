import 'package:flutter/material.dart';
import 'mainpage.dart';
import '../models/mainmodel.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150.0,
              width: 150.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                      'http://worldwideinterweb.com/wp-content/uploads/2017/10/funniest-baby-faces.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 35.0),
              margin: EdgeInsets.all(5.0),
              child: TextField(
                controller: nameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter Hostel Name',
                  labelText: 'Hostel Name',
                  labelStyle: TextStyle(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {},
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 35.0),
              margin: EdgeInsets.all(5.0),
              child: TextField(
                controller: keyController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter Key',
                  labelText: 'Key',
                  labelStyle: TextStyle(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {},
              ),
            ),
            ScopedModelDescendant(
              builder: (BuildContext context, Widget child, MainModel model) {
                return RaisedButton(
                  onPressed: () {
                    model
                        .loginProcess(nameController.text, keyController.text)
                        .then((bool value) {
                      if (value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage()));
                      } else {
                        // Enter correct parameters
                      }
                    });
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
