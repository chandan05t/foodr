import 'package:flutter/material.dart';

class DeliveredOrder {
  final String deliveredOrderId;
  final String itemId;
  final String hostelName;
  final String itemName;
  final String roomNo;
  final int itemCost;
  final int quantity;
  final DateTime dateTime;

  DeliveredOrder(
      {@required this.deliveredOrderId,
      @required this.itemId,
      @required this.hostelName,
      @required this.itemName,
      @required this.roomNo,
      @required this.itemCost,
      @required this.quantity,
      @required this.dateTime});
}
