import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'orderpage.dart';
import 'registerpage.dart';
import 'databasepage.dart';
import 'deliverednotificationpage.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/mainmodel.dart';
import 'itemspage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final List<String> tabs = ['Orders', 'Database', 'Register'];
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void tabfunc() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    tabController.addListener(tabfunc);
    return ScopedModelDescendant(builder: (
      BuildContext context,
      Widget child,
      MainModel model,
    ) {
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
                      'O N L I N E   P I L O T',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    )
                  ],
                ),
              ),
              ListTile(
                title: Text('Items'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => ItemsPage(model)),
                  );
                },
              ),
              ListTile(
                title: Text('F.A.Q s'),
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MainPage()),
                  // );
                },
              ),
              ListTile(
                title: Text('About'),
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MainPage()),
                  // );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          // flexibleSpace: Image.network('http://worldwideinterweb.com/wp-content/uploads/2017/10/funniest-baby-faces.jpg'),
          backgroundColor: Color(0xfffc8019),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.access_alarm),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveredList(model)));
              },
            ),
          ],
          iconTheme: IconThemeData(color: Color(0xfff5f5f5)),
          title: Text(
            'Order Online',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            unselectedLabelColor: Color(0xff353531),
            labelColor: Color(0xfff5f5f5),
            controller: tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.list),
                text: tabs[0],
              ),
              Tab(
                icon: Icon(Icons.info),
                text: tabs[1],
              ),
              Tab(
                icon: Icon(Icons.edit),
                text: tabs[2],
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            OrderList(model),
            DatabasePage(),
            Register(model),
          ],
        ),
      );
    });
  }
}
