import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/mainmodel.dart';
import 'package:flutter/cupertino.dart';
import 'dialog.dart';

class SwipeButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SwipeButtonState();
  }
}

class _SwipeButtonState extends State<SwipeButton> {
  bool accepted = false;
  bool started = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget statusWidget;
        if (accepted && !model.sendingList) {
          statusWidget = Text(
            'Order confirmed',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          );
        } else if (accepted && model.sendingList) {
          statusWidget = SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        } else {
          statusWidget = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Swipe to order ',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              Align(
                widthFactor: 0.33,
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
              Align(
                  widthFactor: 0.33,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  )),
              Align(
                  widthFactor: 0.33,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  )),
            ],
          );
        }
        return Container(
          // color: Colors.white,
          height: 72.0,
          padding: EdgeInsets.fromLTRB(5.0, 7.0, 5.0, 5.0),
          child: Stack(
            children: <Widget>[
              Container(
                height: 60.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  child: Container(
                    color: started ? Theme.of(context).primaryColor : Color(0xfff4ac45),
                    child: Center(
                      child: statusWidget,
                    ),
                  ),
                ),
              ),
              accepted
                  ? Container()
                  : Container(
                      child: Draggable(
                        onDragStarted: () {
                          setState(() {
                            started = true;
                          });
                        },
                        onDragEnd: (details) {
                          setState(() {
                            started = false;
                          });
                        },
                        onDragCompleted: () {
                          setState(() {
                            started = true;
                          });
                        },
                        axis: Axis.horizontal,
                        key: Key('draggable'),
                        child: Container(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            child: Container(
                              color: Theme.of(context).primaryColor,
                              height: 60.0,
                              width: 60.0,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  child: Container(
                                    color: Colors.white,
                                    height: 54.0,
                                    width: 54.0,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.shopping_cart,
                                              color: Theme.of(context).primaryColor,
                                              size: 40.0,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomDialog(model);
                                                  });
                                            },
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                3.0, 0.0, 0.0, 9.0),
                                            child: Text(
                                              model.allPreList.length
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        feedback: Container(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            child: Container(
                              color: Theme.of(context).primaryColor,
                              height: 60.0,
                              width: 60.0,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  child: Container(
                                    color: Colors.white,
                                    height: 54.0,
                                    width: 54.0,
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: Theme.of(context).primaryColor,
                                      size: 40.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Container(),
                        data: 'datapacket',
                      ),
                    ),
              Container(
                alignment: Alignment.topRight,
                child: accepted
                    ? Container()
                    : DragTarget(
                        builder:
                            (context, List<String> datasome, rejectedData) {
                          return Container(
                            height: 55.0,
                            width: 55.0,
                            child: Container(),
                          );
                        },
                        onLeave: (data) {
                          setState(() {
                            model.sendOrderList();
                            accepted = true;
                            model.refreshList();
                          });
                        },
                        onWillAccept: (data) {
                          return true;
                        },
                        onAccept: (data) {
                          setState(() {
                            model.sendOrderList();
                            accepted = true;
                            model.refreshList();
                          });
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
