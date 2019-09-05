import 'package:flutter/material.dart';
import '../models/mainmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

class DeliveredList extends StatefulWidget {
  final MainModel model;

  DeliveredList(this.model);

  @override
  State<StatefulWidget> createState() {
    return _DeliveredListState();
  }
}

class _DeliveredListState extends State<DeliveredList> {
  @override
  void initState() {
    widget.model.getDeliveredOrders('DeliveredOrders_db',
        key: 'HostelName',
        keyValue: widget.model.getHostelName,
        descendingKey: 'CreatedAt');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (
      BuildContext context,
      Widget child,
      MainModel model,
    ) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Delivered Notification'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: model.alldeliveredOrders.length,
            itemBuilder: (context, index) {
              Widget entryCard = Card(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Center(
                            child: Text(
                              model.alldeliveredOrders[index].itemName,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: Text(
                              model.alldeliveredOrders[index].roomNo,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: Text(
                              '₹ ' +
                                  model.alldeliveredOrders[index].itemCost
                                      .toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        DateFormat('jm')
                            .format(model.alldeliveredOrders[index].dateTime),
                        style: TextStyle(fontSize: 10.0),
                      ),
                    )
                  ],
                ),
              );
              Widget dateCard = Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 100.0, vertical: 5.0),
                      padding: EdgeInsets.all(2.0),
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: DateTime.now().year ==
                                model.alldeliveredOrders[index].dateTime.year
                            ? Text(
                                DateFormat('dd MMMM').format(
                                    model.alldeliveredOrders[index].dateTime),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              )
                            : Text(
                                DateFormat('dd MMMM yy').format(
                                    model.alldeliveredOrders[index].dateTime),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                      ),
                    ),
                  ),
                  entryCard,
                ],
              );
              Widget historyCard;
              if (index == 0) {
                historyCard = dateCard;
              } else if (model.alldeliveredOrders[index].dateTime.year ==
                      model.alldeliveredOrders[index - 1].dateTime.year &&
                  model.alldeliveredOrders[index].dateTime.month ==
                      model.alldeliveredOrders[index - 1].dateTime.month &&
                  model.alldeliveredOrders[index].dateTime.day ==
                      model.alldeliveredOrders[index - 1].dateTime.day) {
                historyCard = entryCard;
              } else {
                historyCard = dateCard;
              }
              return historyCard;
            },
          ),
        ),
      );
    });
  }
}
