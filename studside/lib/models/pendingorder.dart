import 'package:flutter/material.dart';

class PendingOrder {
  final String pendingOrderId;
  final String itemId;
  final String hostelName;
  final String itemName;
  final String roomNo;
  final int quantity;
  final int itemCost;
  final bool isAccepted;
  final bool isRejected;
  final DateTime dateTime;

  PendingOrder(
      {@required this.pendingOrderId,
      @required this.itemId,
      @required this.hostelName,
      @required this.itemName,
      @required this.roomNo,
      @required this.quantity,
      @required this.itemCost,
      @required this.isAccepted,
      @required this.isRejected,
      @required this.dateTime});
}
