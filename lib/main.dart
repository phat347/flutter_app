import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/loaders/color_loader_3.dart';
import 'package:flutterapp/loaders/color_loader_5.dart';
import 'package:flutterapp/loaders/dot_type.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        primaryTextTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.black
            )
        ),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<List<NationFootballClub>> _getNationList() async {
    var data = await http
        .get("https://next.json-generator.com/api/json/get/4ykF0L9AH");
    var json_data = jsonDecode(data.body);
    List<NationFootballClub> listClub = [];
    for (var i in json_data) {
      NationFootballClub nationFootballClub = new NationFootballClub(
          i["id"], i["name"], i["img"], i["df"], i["mf"], i["fw"]);
      listClub.add(nationFootballClub);
    }
    return listClub;
  }

  Future<List<NationFootballClub>> _getNationListReload() async {
    var data = await http
        .get("https://next.json-generator.com/api/json/get/4ykF0L9AH");
    var json_data = jsonDecode(data.body);
    List<NationFootballClub> listClub = [];
    for (var i in json_data) {
      NationFootballClub nationFootballClub = new NationFootballClub(
          i["id"], i["name"], i["img"], i["df"], i["mf"], i["fw"]);
      listClub.add(nationFootballClub);
    }
    setState(() {
      return listClub;
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = 0;
    });
  }

  void _decreaseCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter--;
    });
  }

  Color getMyColor(int moneyCounter) {
    if (moneyCounter % 2 == 0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text("PHAT's First Flutter App"),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _getNationListReload,
        child: FutureBuilder(
            future: _getNationList(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: ColorLoader5(
                  dotOneColor: Colors.redAccent,
                  dotTwoColor: Colors.blueAccent,
                  dotThreeColor: Colors.green,
                  dotType: DotType.circle,
                  dotIcon: Icon(Icons.adjust),
                  duration: Duration(seconds: 1),
                ));
              } else {
                return ListView.separated(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        leading: Hero(
                            tag: snapshot.data[index].id,
                            child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snapshot.data[index].img_url),
                                backgroundColor: Colors.transparent)),
                        title: Text(snapshot.data[index].name),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
//                      showToast(snapshot.data[index].name.toString()+"\n"+"Tấn công: "+snapshot.data[index].attack.toString()+", Tiền vệ: "+snapshot.data[index].midfield.toString()+", Phòng thủ: "+snapshot.data[index].defend.toString());
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      DetailNation(snapshot.data[index])));
                        });
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(height: 1);
                  },
                );
              }
            }),
//        child: _myListView(context),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
//        child: Column(
//          // Column is also a layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug painting" (press "p" in the console, choose the
//          // "Toggle Debug Paint" action from the Flutter Inspector in Android
//          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//          // to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'Số chẵn màu xanh, Số lẻ màu đỏ',
//            ),
//            Text.rich(
//              TextSpan(
//                text: 'Số đếm hiện tại: ', // default text style
//                children: <TextSpan>[
//                  TextSpan(text: ' $_counter ',
//                  style: TextStyle(fontStyle: FontStyle.italic,
//                      color: getMyColor(_counter),fontSize: 20,
//                      fontWeight: FontWeight.bold)),
//                ],
//              ),
//            ),
//            SizedBox(height: 20),
//            Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  RaisedButton(
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(18.0),
//                        side: BorderSide(color: Colors.red)),
//                    onPressed: () {_decreaseCounter();},
//                    color: Colors.red,
//                    textColor: Colors.white,
//                    child: Text("TRỪ".toUpperCase(),
//                        style: TextStyle(fontSize: 14)),
//                  ),
//                  SizedBox(width: 10),
//                  RaisedButton(
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(18.0),
//                        side: BorderSide(color: Colors.red)),
//                    onPressed: () {_incrementCounter();},
//                    color: Colors.red,
//                    textColor: Colors.white,
//                    child: Text("Cộng".toUpperCase(),
//                        style: TextStyle(fontSize: 14)),
//                  )
//                ],
//              ),
//              FlatButton(
//                shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(18.0),
//                    side: BorderSide(color: Colors.red)),
//                color: Colors.white,
//                textColor: Colors.red,
//                padding: EdgeInsets.only(left: 30,top: 8,right: 30,bottom: 8),
//                onPressed: () {_resetCounter();},
//                child: Text(
//                  "RESET".toUpperCase(),
//                  style: TextStyle(
//                    fontSize: 14.0,
//                  ),
//                ),
//              ),
//            ])
//
//          ],
//        ),
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Tăng số đếm',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _myListView(BuildContext context) {
    // backing data
    final europeanCountries = [
      'Albania',
      'Andorra',
      'Armenia',
      'Austria',
      'Azerbaijan',
      'Belarus',
      'Belgium',
      'Bosnia and Herzegovina',
      'Bulgaria',
      'Croatia',
      'Cyprus',
      'Czech Republic',
      'Denmark',
      'Estonia',
      'Finland',
      'France',
      'Georgia',
      'Germany',
      'Greece',
      'Hungary',
      'Iceland',
      'Ireland',
      'Italy',
      'Kazakhstan',
      'Kosovo',
      'Latvia',
      'Liechtenstein',
      'Lithuania',
      'Luxembourg',
      'Macedonia',
      'Malta',
      'Moldova',
      'Monaco',
      'Montenegro',
      'Netherlands',
      'Norway',
      'Poland',
      'Portugal',
      'Romania',
      'Russia',
      'San Marino',
      'Serbia',
      'Slovakia',
      'Slovenia',
      'Spain',
      'Sweden',
      'Switzerland',
      'Turkey',
      'Ukraine',
      'United Kingdom',
      'Vatican City'
    ];

    return ListView.separated(
        itemCount: europeanCountries.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.wb_sunny),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Fluttertoast.showToast(
                  msg: europeanCountries[index],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black45,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
            title: Text(europeanCountries[index]),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 0.5,
            height: 1,
          );
        });
  }
}

class DetailNation extends StatelessWidget {
  final NationFootballClub items;

  DetailNation(this.items);

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(items.name),
      ),
      body: Center(
        child: Hero(
            tag: items.id,
            child: CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(items.img_url),
                backgroundColor: Colors.transparent)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showToast(items.name.toString() +
              "\n" +
              "Tấn công: " +
              items.attack.toString() +
              ", Tiền vệ: " +
              items.midfield.toString() +
              ", Phòng thủ: " +
              items.defend.toString());
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NationFootballClub {
  final int id;
  final String name;
  final String img_url;
  final int defend;
  final int midfield;
  final int attack;

  NationFootballClub(this.id, this.name, this.img_url, this.defend,
      this.midfield, this.attack);
}
