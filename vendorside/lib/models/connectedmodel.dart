import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'pendingorder.dart';
import 'deliveredorder.dart';
import 'dart:convert';
import 'dart:core';
import '../info.dart';
import 'items.dart';

mixin ConnectedModel on Model {
  List<PendingOrder> _pendingorders = [];
  List<DeliveredOrder> _deliveredorders = [];
  String hostelName;
  String studentName;
  String balanceAmount;
  List<Items> _itemsList = [];
  bool changeValue = false;
}

mixin MainConnectedModel on ConnectedModel {
  List<PendingOrder> get allPendingOrders {
    return List.from(_pendingorders);
  }

  List<DeliveredOrder> get alldeliveredOrders {
    return List.from(_deliveredorders);
  }

  List<Items> get allItems {
    return List.from(_itemsList);
  }

  String get getHostelName {
    return hostelName;
  }

  String get getStudentName {
    return studentName;
  }

  String get getBalanceAmount {
    return balanceAmount;
  }

  void removePendingOrder(int index) {
    _pendingorders.removeAt(index);
    notifyListeners();
  }

  void acceptPendingOrder(int index) {
    _pendingorders[index].isAccepted = true;
    notifyListeners();
  }

  Future<bool> loginProcess(String loginHostelName, String loginkey) async {
    Map<String, String> loginMap = Map<String, String>();
    loginMap['HostelName'] = loginHostelName;
    loginMap['HostelKey'] = loginkey;
    print(loginHostelName + ' : ' + loginkey);
    http.Response response = await http.post(UrlInfo.fullUrl + 'hostellogin',
        body: json.encode(loginMap));
    if (response.statusCode == 201) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Hostel', loginHostelName);
      hostelName = loginHostelName;
      return true;
    } else {
      return false;
    }
    // http
    //     .post(UrlInfo.fullUrl + 'hostellogin', body: json.encode(loginMap))
    //     .then((http.Response response) async {
    //   if (response.statusCode == 201) {
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     prefs.setString('Hostel', loginHostelName);
    //     hostelName = loginHostelName;
    //     return true;
    //   } else {
    //     return false;
    //   }
    // });
  }

  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('Hostel').toString().isNotEmpty &&
        prefs.get('Hostel') != null) {
      hostelName = prefs.get('Hostel').toString();
      notifyListeners();
    } else {
      hostelName = null;
    }
  }

  void getStudentInfo(String database,
      {String key,
      String keyValue,
      String key2,
      String key2Value,
      String ascendingKey,
      String descendingKey,
      String first}) {
    databaseQueryMap(database,
            key: key,
            keyValue: keyValue,
            key2: key2,
            key2Value: key2Value,
            ascendingKey: ascendingKey,
            descendingKey: descendingKey,
            first: first)
        .then((List<Map<String, dynamic>> queryList) {
      print(queryList);
      studentName = queryList[0]['StudentName'];
      balanceAmount = queryList[0]['Balance'].toString();
      notifyListeners();
    });
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
        if (!query['Rejected']) {
          final PendingOrder pendingOrder = PendingOrder(
              pendingOrderId: query['PrimeId'],
              hostelName: query['HostelName'],
              roomNo: query['RoomNo'],
              itemName: query['ItemName'],
              itemCost: query['ItemCost'],
              itemId: query['ItemId'],
              quantity: query['Quantity'],
              isAccepted: query['Accepted'],
              dateTime: DateTime.parse(query['CreatedAt']));
          _pendingorders.add(pendingOrder);
        }
      });
      notifyListeners();
    });
  }

  void getItemsList(String database,
      {String key,
      String keyValue,
      String key2,
      String key2Value,
      String ascendingKey,
      String descendingKey,
      String first}) {
    _itemsList.clear();
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
        final Items item = Items(
          hostelName: query['HostelName'],
          itemName: query['ItemName'],
          itemCost: query['ItemCost'],
          itemId: query['PrimeId'],
        );
        _itemsList.add(item);
        notifyListeners();
      });
    });
  }

  void getDeliveredOrders(String database,
      {String key,
      String keyValue,
      String key2,
      String key2Value,
      String ascendingKey,
      String descendingKey,
      String first}) {
    _deliveredorders.clear();
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
        final DeliveredOrder deliveredOrder = DeliveredOrder(
          deliveredOrderId: query['PrimeId'],
          hostelName: query['HostelName'],
          roomNo: query['RoomNo'],
          itemName: query['ItemName'],
          itemCost: query['ItemCost'],
          itemId: query['ItemId'],
          quantity: query['Quantity'],
          dateTime: DateTime.parse(query['CreatedAt']),
        );
        _deliveredorders.add(deliveredOrder);
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
    // http.get(getLink).then((http.Response response) {
    //   List<Map<String, dynamic>> queryList =
    //       List<Map<String, dynamic>>.from(json.decode(response.body));
    //   return queryList;
    // });
    http.Response response = await http.get(getLink);
    List<Map<String, dynamic>> queryList =
        List<Map<String, dynamic>>.from(json.decode(response.body));
    return queryList;
  }
}
