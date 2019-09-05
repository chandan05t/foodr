import 'package:flutter/material.dart';
import '../models/mainmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../info.dart';
import 'package:intl/intl.dart';

class OrderList extends StatefulWidget {
  final MainModel model;

  OrderList(this.model);

  @override
  State<StatefulWidget> createState() {
    return _OrderListState();
  }
}

class _OrderListState extends State<OrderList> {
  @override
  void initState() {
    widget.model.getPendingOrders('PendingOrders_db',
        key: 'HostelName',
        keyValue: widget.model.hostelName,
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
      return ListView.builder(
        key: PageStorageKey('PendingOrder'),
        itemCount: model.allPendingOrders.length,
        itemBuilder: (context, index) {
          return model.allPendingOrders[index].isAccepted
              ? Dismissible(
                  key: Key(model.allPendingOrders[index].pendingOrderId),
                  background: Container(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    alignment: Alignment.centerLeft,
                    color: Colors.green,
                    child: Text(
                      'Order Ready',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    http
                        .get(UrlInfo.fullUrl +
                            'ready?PrimeId=' +
                            model.allPendingOrders[index].pendingOrderId)
                        .then((http.Response response) {
                      if (response.statusCode == 201) {
                        model.removePendingOrder(index);
                      }
                    });
                  },
                  child: Card(
                    color: Colors.orange,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                icon: Container(),
                                onPressed: () {},
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  model.allPendingOrders[index].itemName +
                                      ' - ' +
                                      model.allPendingOrders[index].quantity
                                          .toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  model.allPendingOrders[index].roomNo,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                icon: Container(),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 3.0),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            DateFormat('jm')
                                .format(model.allPendingOrders[index].dateTime),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              icon: Image.asset('assets/reject.png'),
                              onPressed: () {
                                http
                                    .get(UrlInfo.fullUrl +
                                        'reject?PrimeId=' +
                                        model.allPendingOrders[index]
                                            .pendingOrderId)
                                    .then((http.Response response) {
                                  if (response.statusCode == 201) {
                                    model.removePendingOrder(index);
                                  }
                                });
                              },
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Center(
                              child: Text(
                                model.allPendingOrders[index].itemName +
                                    ' - ' +
                                    model.allPendingOrders[index].quantity
                                        .toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: Text(
                                model.allPendingOrders[index].roomNo,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: IconButton(
                              icon: Image.asset('assets/accept.png'),
                              onPressed: () {
                                http
                                    .get(UrlInfo.fullUrl +
                                        'accept?PrimeId=' +
                                        model.allPendingOrders[index]
                                            .pendingOrderId)
                                    .then((http.Response response) {
                                  if (response.statusCode == 201) {
                                    model.acceptPendingOrder(index);
                                  }
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 3.0),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          DateFormat('jm')
                              .format(model.allPendingOrders[index].dateTime),
                        ),
                      )
                    ],
                  ),
                );
        },
      );
    });
  }
}
