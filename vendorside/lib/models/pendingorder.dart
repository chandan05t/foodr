import 'package:flutter/material.dart';

class PendingOrder {
  final String pendingOrderId;
  final String itemId;
  final String hostelName;
  final String itemName;
  final String roomNo;
  final int quantity;
  final int itemCost;
  final DateTime dateTime;
  bool isAccepted;

  PendingOrder(
      {@required this.pendingOrderId,
      @required this.itemId,
      @required this.hostelName,
      @required this.itemName,
      @required this.roomNo,
      @required this.quantity,
      @required this.itemCost,
      @required this.dateTime,
      @required this.isAccepted});
}
