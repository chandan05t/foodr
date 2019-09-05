import 'package:flutter/material.dart';
import '../models/mainmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../info.dart';
import 'dart:convert';

class ItemsPage extends StatefulWidget {
  final MainModel model;

  ItemsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ItemsPageState();
  }
}

class _ItemsPageState extends State<ItemsPage> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  FocusNode nameFocusNode;
  FocusNode amountFocusNode;

  @override
  void initState() {
    widget.model.getItemsList(
      'ItemInfo_db',
      key: 'HostelName',
      keyValue: widget.model.getHostelName,
    );
    nameFocusNode = FocusNode();
    amountFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    nameFocusNode.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  void _focusChange(
      BuildContext context, FocusNode currentNode, FocusNode nextFocus) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _addItem() {
    var request = http.MultipartRequest(
        "POST", Uri.parse(UrlInfo.fullUrl + 'menuupdate'));
    request.fields['HostelName'] = widget.model.getHostelName;
    request.fields['ItemName'] = nameController.text;
    request.fields['ItemCost'] = amountController.text;
    request.send().then((http.StreamedResponse response) {
      if (response.statusCode == 201) {
        //success message
      } else {
        //failed message
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Menu'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
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
                          margin: EdgeInsets.fromLTRB(5.0, 35.0, 5.0, 5.0),
                          child: TextField(
                            controller: nameController,
                            focusNode: nameFocusNode,
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Enter Item Name.',
                              labelText: 'Item Name',
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
                              _focusChange(
                                  context, nameFocusNode, amountFocusNode);
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
                              hintText: 'Enter Item Cost',
                              labelText: 'Item Cost',
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
                              _addItem();
                            },
                          ),
                        ),
                        Center(
                          child: RaisedButton(
                            onPressed: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _addItem();
                            },
                            child: Text(
                              'Add Item',
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
              FocusScope.of(context).requestFocus(nameFocusNode);
            },
          ),
          body: ListView.builder(
            itemCount: model.allItems.length,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Center(
                          child: Text(
                            model.allItems[index].itemName,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: Text(
                              '₹ ' + model.allItems[index].itemCost.toString()),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              Map<String, String> menumap = Map();
                              menumap['PrimeId'] = model.allItems[index].itemId;
                              http
                                  .post(UrlInfo.fullUrl + 'menudelete',
                                      body: json.encode(menumap))
                                  .then((http.Response response) {
                                if (response.statusCode == 201) {
                                  //Success message
                                } else {
                                  //failed message
                                }
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
