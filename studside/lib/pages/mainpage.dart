import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/swipebutton.dart';
import '../models/mainmodel.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/items.dart';
import 'historypage.dart';
import '../widgets/menulayout.dart';
import 'notificationpage.dart';

class MainPage extends StatefulWidget {
  final MainModel model;

  MainPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  bool listloading = false;

  @override
  void initState() {
    widget.model
        .getItemList('ItemInfo_db',
            key: 'HostelName', keyValue: widget.model.hostelName)
        .then((int length) {
      listloading = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xfffc8019),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'S T U D  S I D E',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text('Order History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            HistoryList(widget.model)));
              },
            ),
            ListTile(
              title: Text('Tile 2'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Tile 3'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size(25.0, 59.0),
          child: Container(),
        ),
        flexibleSpace: Image.asset(
          'assets/appbar.jpg',
          fit: BoxFit.fill,
        ),
        iconTheme: IconThemeData(color: Color(0xfff5f5f5)),
        actions: <Widget>[
          IconButton(
            color: Color(0xfff5f5f5),
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationPage(widget.model)));
            },
          )
        ],
        // title: Text('Stud Side'),
      ),
      body: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          List<Items> itemsList = model.allItems;
          return listloading
              ? Stack(
                  children: <Widget>[
                    Container(
                      margin: model.allPreList.length > 0
                          ? EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 72.0)
                          : EdgeInsets.all(0.0),
                      child: ListView.builder(
                        itemCount: itemsList.length % 2 == 0
                            ? (itemsList.length ~/ 2)
                            : (itemsList.length ~/ 2 + 1),
                        itemBuilder: (context, index) {
                          return Row(
                            children: <Widget>[
                              MenuLayout(index * 2, model),
                              itemsList.length > (index * 2 + 1)
                                  ? MenuLayout(index * 2 + 1, model)
                                  : Flexible(
                                      flex: 1,
                                      child: Container(),
                                    ),
                            ],
                          );
                        },
                      ),
                    ),
                    model.allPreList.length > 0
                        ? Container(
                            child: SwipeButton(),
                            alignment: Alignment.bottomCenter,
                          )
                        : Container()
                  ],
                )
              : Container();
        },
      ),
    );
  }
}
