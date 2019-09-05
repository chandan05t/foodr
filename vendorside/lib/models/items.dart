import 'package:flutter/material.dart';

class Items {
  final String itemId;
  final String hostelName;
  final String itemName;
  final int itemCost;

  Items({
    @required this.itemId,
    @required this.hostelName,
    @required this.itemName,
    @required this.itemCost,
  });
}
