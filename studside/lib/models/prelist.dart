import 'package:flutter/material.dart';

class PreList {
  final String itemId;
  final String hostelName;
  final String itemName;
  int itemCost;
  int quantity;

  PreList({
    @required this.itemId,
    @required this.hostelName,
    @required this.itemName,
    @required this.itemCost,
    @required this.quantity,
  });
}
