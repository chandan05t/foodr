import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../info.dart';
import 'fullhistory.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/mainmodel.dart';
import 'dart:convert';

class DatabasePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DatabasePageState();
  }
}

class _DatabasePageState extends State<DatabasePage> {
  final roomController = TextEditingController();
  final amountController = TextEditingController();
  FocusNode roomFocusNode;
  FocusNode amountFocusNode;

  @override
  void initState() {
    roomFocusNode = FocusNode();
    amountFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    roomController.dispose();
    amountController.dispose();
    roomFocusNode.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  void focusMethod(String value) {
    var cursorPos = roomController.selection;
    roomController.text = value ?? '';
    cursorPos = new TextSelection.fromPosition(
        new TextPosition(offset: roomController.text.length));
    roomController.selection = cursorPos;
    FocusScope.of(context).requestFocus(roomFocusNode);
  }

  void _focusChange(
      BuildContext context, FocusNode currentNode, FocusNode nextFocus) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _balanceUpdate(MainModel model) {
    if (roomController.text != null && amountController.text != null) {
      Map<String, String> balanceMap = Map();
      balanceMap['HostelName'] = model.hostelName;
      balanceMap['RoomNo'] = roomController.text;
      balanceMap['Amount'] = amountController.text;
      http
          .post(UrlInfo.fullUrl + 'offlineamount',
              body: json.encode(balanceMap))
          .then((http.Response response) {
        if (response.statusCode == 201) {
          roomController.clear();
          amountController.clear();
        }
      });
    } else {
      //Remind to complete the full form
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.fromLTRB(25.0, 25.0, 0, 0),
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: roomController,
                          focusNode: roomFocusNode,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Enter Room No',
                            labelText: 'Room No',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String value) {},
                          onSubmitted: (String value) {
                            _focusChange(
                                context, roomFocusNode, amountFocusNode);
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.fromLTRB(25.0, 15.0, 0, 0),
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          controller: amountController,
                          focusNode: amountFocusNode,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Enter Amount',
                            labelText: 'Amount',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String value) {},
                          onSubmitted: (String value) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            _balanceUpdate(model);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _balanceUpdate(model);
                            },
                            child: Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 25.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          'Full History',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          amountController.clear();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullHistoryPage(
                                      model, roomController.text)));
                        },
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          'A',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          focusMethod("A");
                        },
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          'B',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          focusMethod("B");
                        },
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          'C',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          focusMethod("C");
                        },
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          'F',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          focusMethod("F");
                        },
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          'S',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          focusMethod("S");
                        },
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          'T',
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          focusMethod("T");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(15.0),
              child: Text(
                "Today's Earning : ----",
                style: TextStyle(fontSize: 18.0, color: Theme.of(context).primaryColor),
              ),
            )
          ],
        );
      },
    );
  }
}
