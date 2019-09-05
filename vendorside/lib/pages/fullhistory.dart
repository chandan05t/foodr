import 'package:flutter/material.dart';
import '../models/mainmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../info.dart';
import 'dart:convert';

class FullHistoryPage extends StatefulWidget {
  final MainModel model;
  final String roomNo;
  FullHistoryPage(this.model, this.roomNo);

  @override
  State<StatefulWidget> createState() {
    return _FullHistoryPageState();
  }
}

class _FullHistoryPageState extends State<FullHistoryPage> {
  final amountController = TextEditingController();
  FocusNode amountFocusNode;

  @override
  void initState() {
    widget.model.getStudentInfo('StudInfo_db',
        key: 'HostelName',
        keyValue: widget.model.hostelName,
        key2: 'RoomNo',
        key2Value: widget.roomNo);
    widget.model.getDeliveredOrders('DeliveredOrders_db',
        key: 'HostelName',
        keyValue: widget.model.hostelName,
        key2: 'RoomNo',
        key2Value: widget.roomNo,
        descendingKey: 'CreatedAt');
    amountFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  void _recharge() {
    Map<String, String> rechargeMap = Map<String, String>();
    rechargeMap['HostelName'] = widget.model.hostelName;
    rechargeMap['RoomNo'] = widget.roomNo;
    rechargeMap['Amount'] = amountController.text;
    http
        .post(UrlInfo.fullUrl + 'rechargeamount', body: json.encode(rechargeMap))
        .then((http.Response response) {
      if (response.statusCode == 201) {
        //Show Success message
      } else {
        //Show failed message
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(model.getStudentName),
                        Text(widget.roomNo),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('Balance'),
                        Text(model.getBalanceAmount),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.model.alldeliveredOrders.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 5.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Center(
                                        child: Text(
                                          widget.model.alldeliveredOrders[index]
                                                  .itemName +
                                              ' x ' +
                                              widget
                                                  .model
                                                  .alldeliveredOrders[index]
                                                  .quantity
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 20.0,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Center(
                                        child: Text('₹ ' +
                                            widget
                                                .model
                                                .alldeliveredOrders[index]
                                                .itemCost
                                                .toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        DateFormat('dd-MM-yy').format(model
                                            .alldeliveredOrders[index]
                                            .dateTime),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        DateFormat('jm').format(model
                                            .alldeliveredOrders[index]
                                            .dateTime),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 50.0),
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Center(
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text('Recharge Amount'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 35.0),
                                margin:
                                    EdgeInsets.fromLTRB(5.0, 25.0, 5.0, 5.0),
                                child: TextField(
                                  controller: amountController,
                                  focusNode: amountFocusNode,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Recharge Amount',
                                    labelText: 'Recharge Amount',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  onSubmitted: (String value) {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    _recharge();
                                  },
                                ),
                              ),
                              Center(
                                child: RaisedButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    _recharge();
                                  },
                                  child: Text(
                                    'Recharge',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                    FocusScope.of(context).requestFocus(amountFocusNode);
                  },
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
