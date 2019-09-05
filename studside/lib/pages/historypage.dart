import 'package:flutter/material.dart';
import '../models/mainmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

class HistoryList extends StatefulWidget {
  final MainModel model;

  HistoryList(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HistoryListState();
  }
}

class _HistoryListState extends State<HistoryList> {
  @override
  void initState() {
    widget.model.getOrderHistory('DeliveredOrders_db',
        key: 'HostelName',
        keyValue: widget.model.hostelName,
        key2: 'RoomNo',
        key2Value: widget.model.roomNo,
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
          title: Text('Order History'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: model.allOrderHistory.length,
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
                          flex: 4,
                          child: Center(
                            child: Text(
                              model.allOrderHistory[index].itemName +
                                  ' x ' +
                                  model.allOrderHistory[index].quantity
                                      .toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Center(
                            child: Text(
                              '₹ ' +
                                  model.allOrderHistory[index].itemCost
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
                            .format(model.allOrderHistory[index].dateTime),
                        style: TextStyle(fontSize: 10.0),
                      ),
                    )
                  ],
                ),
              );
              Widget dateCard = Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 100.0, vertical: 5.0),
                      padding: EdgeInsets.all(2.0),
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: DateTime.now().year ==
                                model.allOrderHistory[index].dateTime.year
                            ? Text(
                                DateFormat('dd MMMM').format(
                                    model.allOrderHistory[index].dateTime),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              )
                            : Text(
                                DateFormat('dd MMMM yy').format(
                                    model.allOrderHistory[index].dateTime),
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
              } else if (model.allOrderHistory[index].dateTime.year ==
                      model.allOrderHistory[index - 1].dateTime.year &&
                  model.allOrderHistory[index].dateTime.month ==
                      model.allOrderHistory[index - 1].dateTime.month &&
                  model.allOrderHistory[index].dateTime.day ==
                      model.allOrderHistory[index - 1].dateTime.day) {
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
