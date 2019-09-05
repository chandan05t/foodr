import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../info.dart';
import 'pendingorder.dart';
import 'orderhistory.dart';
import 'items.dart';
import 'prelist.dart';
import 'dart:convert';
import 'dart:async';

mixin ConnectedModel on Model {
  List<PendingOrder> _pendingorders = [];
  List<OrderHistory> _orderhistory = [];
  List<Items> _items = [];
  List<PreList> _preList = [];
  List<int> quantityList;
  bool sendingList = false;
  String hostelName;
  String roomNo;
  String studentPrimeId;
}

mixin MainConnectedModel on ConnectedModel {
  List<PendingOrder> get allPendingOrders {
    return List.from(_pendingorders);
  }

  List<OrderHistory> get allOrderHistory {
    return List.from(_orderhistory);
  }

  List<Items> get allItems {
    return List.from(_items);
  }

  List<PreList> get allPreList {
    return List.from(_preList);
  }

  String get getHostelName {
    return hostelName;
  }

  String get getStudentPrimeId {
    return studentPrimeId;
  }

  String get getRoomNo {
    return roomNo;
  }

  void addQuantity(int index) {
    quantityList[index] += 1;
    notifyListeners();
  }

  void removeQuantity(int index) {
    quantityList[index] -= 1;
    notifyListeners();
  }

  void addQuantityPreList(int index) {
    _preList[index].quantity += 1;
    int itemIndex = _items.indexWhere((Items item) {
      return item.itemId == _preList[index].itemId;
    });
    _preList[index].itemCost =
        _preList[index].quantity * _items[itemIndex].itemCost;
    quantityList[itemIndex] += 1;
    notifyListeners();
  }

  void removeQuantityPreList(int index) {
    _preList[index].quantity -= 1;
    int itemIndex = _items.indexWhere((Items item) {
      return item.itemId == _preList[index].itemId;
    });
    _preList[index].itemCost =
        _preList[index].quantity * _items[itemIndex].itemCost;
    quantityList[itemIndex] -= 1;
    if (_preList[index].quantity == 0) {
      removeItemPreList(index);
    }
    notifyListeners();
  }

  void removeItemPreList(int index) {
    int itemIndex = _items.indexWhere((Items item) {
      return item.itemId == _preList[index].itemId;
    });
    quantityList[itemIndex] = 0;
    _preList.removeAt(index);
    notifyListeners();
  }

  Future refreshList() {
    return Future.delayed(Duration(seconds: 3), () {
      _preList.clear();
      quantityList = List.filled(allItems.length, 0);
      notifyListeners();
    });
  }

  Future<bool> loginProcess(String loginStudentPrimeId, String loginHostelName,
      String loginRoomNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Hostel', loginHostelName);
    prefs.setString('RoomNo', loginRoomNo);
    prefs.setString('PrimeId', loginStudentPrimeId);
    hostelName = loginHostelName;
    roomNo = loginRoomNo;
    studentPrimeId = loginStudentPrimeId;
    return true;
  }

  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('Hostel').toString().isNotEmpty &&
        prefs.get('RoomNo').toString().isNotEmpty &&
        prefs.get('PrimeId').toString().isNotEmpty &&
        prefs.get('PrimeId') != null &&
        prefs.get('Hostel') != null &&
        prefs.get('RoomNo') != null) {
      hostelName = prefs.get('Hostel').toString();
      roomNo = prefs.get('RoomNo').toString();
      studentPrimeId = prefs.get('PrimeId').toString();
      notifyListeners();
    } else {
      hostelName = null;
      roomNo = null;
      studentPrimeId = null;
    }
  }

  void addToPreList(Items item, int quantity) {
    int index = _preList.indexWhere((PreList note) {
      return note.itemId == item.itemId;
    });
    if (index < 0 && quantity > 0) {
      _preList.add(PreList(
        itemId: item.itemId,
        hostelName: item.hostelName,
        itemName: item.itemName,
        itemCost: quantity * item.itemCost,
        quantity: quantity,
      ));
    } else if (index >= 0 && quantity > 0) {
      _preList[index].quantity = quantity;
      _preList[index].itemCost = quantity * item.itemCost;
    } else {
      _preList.removeAt(index);
    }
    notifyListeners();
  }

  void sendOrderList() {
    sendingList = true;
    notifyListeners();
    List<Map<String, dynamic>> premaplist = [];
    _preList.forEach((PreList prelist) {
      Map<String, dynamic> premap = Map<String, dynamic>();
      premap['HostelName'] = prelist.hostelName;
      premap['ItemCost'] = prelist.itemCost;
      premap['ItemId'] = prelist.itemId;
      premap['ItemName'] = prelist.itemName;
      premap['Quantity'] = prelist.quantity;
      premap['RoomNo'] = getRoomNo;
      premaplist.add(premap);
    });
    http
        .post(UrlInfo.fullUrl + 'studentorder', body: json.encode(premaplist))
        .then((http.Response response) {
      sendingList = false;
      notifyListeners();
    });
  }

  Future<int> getItemList(String database,
      {String key,
      String keyValue,
      String key2,
      String key2Value,
      String ascendingKey,
      String descendingKey,
      String first}) async {
    _items.clear();
    await databaseQueryMap(database,
            key: key,
            keyValue: keyValue,
            key2: key2,
            key2Value: key2Value,
            ascendingKey: ascendingKey,
            descendingKey: descendingKey,
            first: first)
        .then((List<Map<String, dynamic>> queryList) {
      queryList.forEach((Map<String, dynamic> query) {
        final Items itemInfo = Items(
          hostelName: query['HostelName'],
          itemName: query['ItemName'],
          itemCost: query['ItemCost'],
          itemId: query['PrimeId'],
        );
        _items.add(itemInfo);
      });
      notifyListeners();
    });
    quantityList = List.filled(allItems.length, 0);
    return allItems.length;
  }

  void getPendingOrders(String database,
      {String key,
      String keyValue,
      String key2,
      String key2Value,
      String ascendingKey,
      String descendingKey,
      String first}) {
    _pendingorders.clear();
    databaseQueryMap(database,
            key: key,
            keyValue: keyValue,
            key2: key2,
            key2Value: key2Value,
            ascendingKey: ascendingKey,
            descendingKey: descendingKey,
            first: first)
        .then((List<Map<String, dynamic>> queryList) {
      queryList.forEach((Map<String, dynamic> query) {
        final PendingOrder pendingOrder = PendingOrder(
            pendingOrderId: query['PrimeId'],
            hostelName: query['HostelName'],
            roomNo: query['RoomNo'],
            itemName: query['ItemName'],
            itemCost: query['ItemCost'],
            itemId: query['ItemId'],
            quantity: query['Quantity'],
            isAccepted: query['Accepted'],
            isRejected: query['Rejected'],
            dateTime: DateTime.parse(query['CreatedAt']));
        _pendingorders.add(pendingOrder);
      });
      notifyListeners();
    });
  }

  void getOrderHistory(String database,
      {String key,
      String keyValue,
      String key2,
      String key2Value,
      String ascendingKey,
      String descendingKey,
      String first}) {
    _orderhistory.clear();
    databaseQueryMap(database,
            key: key,
            keyValue: keyValue,
            key2: key2,
            key2Value: key2Value,
            ascendingKey: ascendingKey,
            descendingKey: descendingKey,
            first: first)
        .then((List<Map<String, dynamic>> queryList) {
      queryList.forEach((Map<String, dynamic> query) {
        final OrderHistory deliveredOrder = OrderHistory(
            deliveredOrderId: query['PrimeId'],
            hostelName: query['HostelName'],
            roomNo: query['RoomNo'],
            itemName: query['ItemName'],
            itemCost: query['ItemCost'],
            itemId: query['ItemId'],
            quantity: query['Quantity'],
            dateTime: DateTime.parse(query['CreatedAt']));
        _orderhistory.add(deliveredOrder);
        notifyListeners();
      });
    });
  }

  Future<List<Map<String, dynamic>>> databaseQueryMap(String database,
      {String key,
      String keyValue,
      String key2,
      String key2Value,
      String ascendingKey,
      String descendingKey,
      String first}) async {
    Map<String, dynamic> queryMap = Map();

    queryMap['Database_Table'] = database;
    if (key != null && keyValue != null) {
      queryMap['Key'] = key;
      queryMap['Key_Value'] = keyValue;
    }
    if (key2 != null && key2Value != null) {
      queryMap['Key2'] = key2;
      queryMap['Key2_Value'] = key2Value;
    }
    if (ascendingKey != null) {
      queryMap['AscendingKey'] = ascendingKey;
    } else if (descendingKey != null) {
      queryMap['DescendingKey'] = descendingKey;
    }
    if (first != null) {
      queryMap['First'] = 'first';
    }
    Uri getLink = Uri(
      scheme: UrlInfo.scheme,
      host: UrlInfo.host,
      port: UrlInfo.port,
      path: 'query',
      queryParameters: queryMap,
    );

    http.Response response = await http.get(getLink);
    List<Map<String, dynamic>> queryList =
        List<Map<String, dynamic>>.from(json.decode(response.body));
    return queryList;
  }
}
