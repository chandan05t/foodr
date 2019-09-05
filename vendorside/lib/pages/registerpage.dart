import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../info.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/mainmodel.dart';

class Register extends StatefulWidget {
  final MainModel model;
  Register(this.model);
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final nameController = TextEditingController();
  final roomController = TextEditingController();
  final rollController = TextEditingController();
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  FocusNode nameFocusNode;
  FocusNode roomFocusNode;
  FocusNode rollFocusNode;
  FocusNode phoneFocusNode;
  FocusNode amountFocusNode;

  @override
  void initState() {
    nameFocusNode = FocusNode();
    roomFocusNode = FocusNode();
    rollFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    amountFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    roomController.dispose();
    rollController.dispose();
    phoneController.dispose();
    amountController.dispose();
    nameFocusNode.dispose();
    roomFocusNode.dispose();
    rollFocusNode.dispose();
    phoneFocusNode.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  void _focusChange(
      BuildContext context, FocusNode currentNode, FocusNode nextFocus) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            margin: EdgeInsets.all(5.0),
            child: TextField(
              controller: nameController,
              focusNode: nameFocusNode,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter Name',
                labelText: 'Name',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _focusChange(context, nameFocusNode, roomFocusNode);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            margin: EdgeInsets.all(5.0),
            child: TextField(
              controller: roomController,
              focusNode: roomFocusNode,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter Room No.',
                labelText: 'Room No.',
                labelStyle: TextStyle(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _focusChange(context, roomFocusNode, rollFocusNode);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            margin: EdgeInsets.all(5.0),
            child: TextField(
              controller: rollController,
              focusNode: rollFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Enter Roll No',
                labelText: 'Roll No',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _focusChange(context, rollFocusNode, phoneFocusNode);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            margin: EdgeInsets.all(5.0),
            child: TextField(
              controller: phoneController,
              focusNode: phoneFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Enter Phone No',
                labelText: 'Phone No',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _focusChange(context, phoneFocusNode, amountFocusNode);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            margin: EdgeInsets.all(5.0),
            child: TextField(
              controller: amountController,
              focusNode: amountFocusNode,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLines: null,
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
              onSubmitted: (String value) {
                FocusScope.of(context).requestFocus(new FocusNode());
                _registerForm();
              },
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _registerForm();
              },
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }

  void _registerForm() {
    if (nameController.text != null &&
        roomController.text != null &&
        rollController.text != null &&
        phoneController.text != null &&
        amountController.text != null) {
      var request =
          http.MultipartRequest("POST", Uri.parse(UrlInfo.fullUrl + 'create'));
      request.fields['StudentName'] = nameController.text;
      request.fields['HostelName'] = widget.model.getHostelName;
      request.fields['RoomNo'] = roomController.text;
      request.fields['RollNo'] = rollController.text;
      request.fields['PhoneNo'] = phoneController.text;
      request.fields['Balance'] = amountController.text;
      request.send().then((http.StreamedResponse response) {
        if (response.statusCode == 201) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              var qrList = [
                response.headers['primeid'].toString(),
                roomController.text,
                widget.model.getHostelName
              ];
              nameController.clear();
              roomController.clear();
              rollController.clear();
              phoneController.clear();
              amountController.clear();
              return Dialog(
                child: QrImage(
                  data: qrList.toString(),
                  size: 300.0,
                ),
              );
            },
          );
        }
      });
    } else {
      //Remind to complete the full form
    }
  }
}
