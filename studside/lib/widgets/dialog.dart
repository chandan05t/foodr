import 'package:flutter/material.dart';
import '../models/mainmodel.dart';
import '../models/prelist.dart';

class CustomDialog extends StatefulWidget {
  final MainModel model;
  CustomDialog(this.model);
  @override
  State<StatefulWidget> createState() {
    return _CustomDialogState();
  }
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    int totalAmount = 0;
    widget.model.allPreList.forEach((PreList preList) {
      totalAmount += preList.itemCost;
    });
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                'Your Cart',
                style: TextStyle(fontSize: 19.0),
              ),
            ),
          ),
          widget.model.allPreList.length != 0
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.model.allPreList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 1.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            style: BorderStyle.solid,
                            color: Theme.of(context).primaryColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 4,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 7.0, 0, 0),
                                  child: Center(
                                    child: Text(
                                      widget.model.allPreList[index].itemName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 20.0,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.0),
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.tight,
                                        flex: 3,
                                        child: IconButton(
                                          iconSize: 15.0,
                                          padding: EdgeInsets.fromLTRB(
                                             0.0, 0.0, 0.0, 0.0),
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            if (widget.model.allPreList[index]
                                                    .quantity >
                                                0) {
                                              setState(() {
                                                widget.model
                                                    .removeQuantityPreList(
                                                        index);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.tight,
                                        flex: 3,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 0.0, 0.0, 0.0),
                                          child: Center(
                                            child: Text(
                                              widget.model.allPreList[index]
                                                  .quantity
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Theme.of(context).primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        fit: FlexFit.tight,
                                        child: IconButton(
                                          iconSize: 15.0,
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 0.0, 0.0, 0.0),
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              widget.model
                                                  .addQuantityPreList(index);
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: Text('₹ ' +
                                  widget.model.allPreList[index].itemCost
                                      .toString()),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 12.0, 0, 0),
                              child: Center(
                                child: Container(
                                  height: 35.0,
                                  child: IconButton(
                                    icon: Image.asset('assets/bin.png'),
                                    onPressed: () {
                                      setState(() {
                                        widget.model.removeItemPreList(index);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Container(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text('The Cart is Empty'),
                  ),
                ),
          widget.model.allPreList.length != 0
              ? Container(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text('Total : ₹ ' + totalAmount.toString()),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
