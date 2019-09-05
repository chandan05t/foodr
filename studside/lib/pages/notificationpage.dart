import 'package:flutter/material.dart';
import '../models/mainmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  final MainModel model;

  NotificationPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _NotificationPageState();
  }
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    widget.model.getPendingOrders('PendingOrders_db',
        key: 'HostelName',
        keyValue: widget.model.hostelName,
        key2: 'RoomNo',
        key2Value: widget.model.roomNo,
        descendingKey: 'CreatedAt');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'),
      ),
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return ListView.builder(
            itemCount: model.allPendingOrders.length,
            itemBuilder: (context, index) {
              Color colorVariable;
              String orderStatus;
              if (model.allPendingOrders[index].isRejected &&
                  !model.allPendingOrders[index].isAccepted) {
                colorVariable = Colors.red;
                orderStatus = 'Vendor reject your order.';
              } else if (model.allPendingOrders[index].isAccepted &&
                  !model.allPendingOrders[index].isRejected) {
                colorVariable = Colors.orange;
                orderStatus = 'Your order is accepted and is being prepared.';
              } else if (model.allPendingOrders[index].isRejected &&
                  model.allPendingOrders[index].isAccepted) {
                colorVariable = Colors.green;
                orderStatus =
                    'Your order is ready. Please collect from canteen.';
              } else {
                colorVariable = Colors.grey;
                orderStatus = 'Waiting for conformation from vendor.';
              }
              return Card(
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: 10.0,
                        height: 55.0,
                        color: colorVariable,
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                              child: Text(
                                model.allPendingOrders[index].itemName +
                                    ' x ' +
                                    model.allPendingOrders[index].quantity
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 8.0),
                              child: Text(
                                orderStatus,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          DateFormat('jm')
                              .format(model.allPendingOrders[index].dateTime),
                          style: TextStyle(fontSize: 10.0),
                        ),
                        alignment: Alignment.bottomRight,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
