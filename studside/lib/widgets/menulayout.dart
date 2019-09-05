import 'package:flutter/material.dart';
import '../models/mainmodel.dart';

class MenuLayout extends StatefulWidget {
  final int index;
  final MainModel model;

  MenuLayout(this.index, this.model);

  @override
  State<StatefulWidget> createState() {
    return _MenuLayoutState();
  }
}

class _MenuLayoutState extends State<MenuLayout> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        margin: EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 6.0),
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border(
            top: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            left: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            right: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            bottom: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Text(
                        widget.model.allItems[widget.index].itemName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 2.0),
                    padding: EdgeInsets.all(3.0),
                  ),
                  Container(
                    // padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: IconButton(
                            icon: Icon(
                              Icons.remove,
                            ),
                            iconSize: 15.0,
                            onPressed: () {
                              if (widget.model.quantityList[widget.index] > 0) {
                                widget.model.removeQuantity(widget.index);
                              }
                            },
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                            decoration: BoxDecoration(
                              // borderRadius:
                              //     BorderRadius.circular(10.0),
                              border: Border(
                                top: BorderSide(color: Theme.of(context).primaryColor),
                                left: BorderSide(color: Theme.of(context).primaryColor),
                                right: BorderSide(color: Theme.of(context).primaryColor),
                                bottom: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                            ),
                            child: Text(widget.model.quantityList[widget.index]
                                .toString()),
                          ),
                        ),
                        Flexible(
                            flex: 3,
                            child: IconButton(
                              iconSize: 15.0,
                              icon: Icon(Icons.add),
                              onPressed: () {
                                widget.model.addQuantity(widget.index);
                              },
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text('₹ ' +
                        widget.model.allItems[widget.index].itemCost
                            .toString()),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 20.0,
                    width: 40.0,
                    child: RaisedButton(
                      padding: EdgeInsets.all(0.0),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'ADD',
                        style: TextStyle(fontSize: 11.0),
                      ),
                      onPressed: () {
                        widget.model.addToPreList(
                            widget.model.allItems[widget.index],
                            widget.model.quantityList[widget.index]);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
