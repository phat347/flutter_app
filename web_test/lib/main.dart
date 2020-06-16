import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:web_test/loaders/color_loader_5.dart';
import 'package:web_test/loaders/dot_type.dart';
import 'package:web_test/models/Submission.dart';


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
        fontFamily: 'Roboto',
        primarySwatch: Colors.red,
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
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
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Submission> itemsData = [];

  int _counter = 0;
  Future myFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
//    controller.addListener(() {
//      double value = controller.offset / 119;
//
//      setState(() {
//        topContainer = value;
//        closeTopContainer = controller.offset > 50;
//      });
//    });
    myFuture = getListSub();
  }

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

  Future<List<Submission>> getListSub() async {
    var data_server = await http
        .get("https://next.json-generator.com/api/json/get/EyGudVOhu");
    List<dynamic> json_data = jsonDecode(data_server.body);
    List<Submission> data =
    json_data.map((json_data) => Submission.fromJson(json_data)).toList();

    setState(() {
      itemsData = data;
    });

    return data;
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
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _decreaseCounter() {
    setState(() {
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
//    Fluttertoast.showToast(
//        msg: msg,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIosWeb: 1,
//        backgroundColor: Colors.black45,
//        textColor: Colors.white,
//        fontSize: 16.0);
  }

  CircleAvatar getAvatarUser(Submission items) {
    if (items.isVipCheck()) {
      return CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(items.portrait_url),
          backgroundColor: Colors.transparent);
    } else {
      return CircleAvatar(
          radius: 20,
          child: CircleAvatar(
              radius: 19,
              backgroundImage: NetworkImage(items.portrait_url),
              backgroundColor: Colors.transparent),
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.chat,
            color: Colors.black,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () {},
            )
          ],
          brightness: Brightness.light,
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: getListSub,
          child: FutureBuilder(
              future: myFuture,
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
                  return Container(
                    height: size.height,
                    child: Column(
                      children: <Widget>[
//                        AnimatedOpacity(
//                          duration: const Duration(milliseconds: 200),
//                          opacity: closeTopContainer ? 0 : 1,
//                          child: AnimatedContainer(
//                              duration: const Duration(milliseconds: 200),
//                              width: size.width,
//                              alignment: Alignment.topCenter,
//                              height: closeTopContainer ? 0 : categoryHeight,
//                              child: categoriesScroller),
//                        ),
                        Expanded(
                            child: ListView.builder(
//                                controller: controller,
                                itemCount: itemsData.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var itemSub = itemsData[index];
                                  double scale = 1.0;
                                  if (topContainer > 0.5) {
                                    scale = index + 0.5 - topContainer;
                                    if (scale < 0) {
                                      scale = 0;
                                    } else if (scale > 1) {
                                      scale = 1;
                                    }
                                  }
                                  return Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                Colors.black.withAlpha(100),
                                                blurRadius: 10.0),
                                          ]),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                height: 300,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          itemSub.URL_img_id)),
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(
                                                          10.0),
                                                      topRight:
                                                      Radius.circular(
                                                          10.0)),
                                                )),
                                            SizedBox(width: 10),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: <Widget>[
                                                      getAvatarUser(itemSub),
                                                      SizedBox(width: 5),
                                                      Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: <Widget>[
                                                            Text(
                                                              itemSub.user_name,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                  'RobotoMedium',
                                                                  color: itemSub
                                                                      .isVipCheck()
                                                                      ? Colors
                                                                      .black
                                                                      : Colors.red),
                                                            ),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Visibility(
                                                                  visible:
                                                                  itemSub.isVipCheck()?false:true,
                                                                  child:
                                                                  Container(
                                                                      decoration: new BoxDecoration(
                                                                          color: Colors.red,
                                                                          borderRadius: new BorderRadius.all(Radius.circular(8))),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left: 2,
                                                                            right: 2,
                                                                            top: 2,
                                                                            bottom: 2),
                                                                        child:
                                                                        Center(
                                                                          child: Text(
                                                                            "Super VIP".toUpperCase(),
                                                                            style: TextStyle(fontSize: 7, fontFamily: 'RobotoBold', color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  itemSub
                                                                      .rank_desc,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      11,
                                                                      fontFamily:
                                                                      'RobotoRegular',
                                                                      color: Colors.red),
                                                                ),
                                                              ],
                                                            )
                                                          ]),
                                                    ],
                                                  ),
                                                  Text(
                                                    itemSub.class_desc,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                        'RobotoMedium',
                                                        fontSize: 20),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    itemSub.extra_desc,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontFamily:
                                                        'RobotoRegular',
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
//                                                  Text(
//                                                    itemSub.extra_desc,
//                                                    overflow: TextOverflow.ellipsis,
//                                                    maxLines: 1,
//                                                    style: const TextStyle(
//                                                        fontSize: 15,
//                                                        fontFamily: 'RobotoRegular',
//                                                        color: Colors.black),
//                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                                })),
                      ],
                    ),
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
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: ImageIcon(
                  AssetImage("assets/launcher/combinedshape.png"),
                  color: Colors.red),
              icon: ImageIcon(AssetImage("assets/launcher/combinedshape.png"),
                  color: Colors.grey),
              title: Padding(
                padding: EdgeInsets.all(0),
                child: Text('Trang chủ'),
              ),
            ),
            BottomNavigationBarItem(
              activeIcon: ImageIcon(
                  AssetImage("assets/launcher/menu_khoqua.png"),
                  color: Colors.red),
              icon: ImageIcon(AssetImage("assets/launcher/menu_khoqua.png"),
                  color: Colors.grey),
              title: Padding(
                padding: EdgeInsets.all(0),
                child: Text('Kho quà'),
              ),
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.camera, color: Colors.red),
              icon: Icon(Icons.camera, color: Colors.grey),
              title: Padding(
                padding: EdgeInsets.all(0),
                child: Text('Chụp ảnh'),
              ),
            ),
            BottomNavigationBarItem(
              activeIcon: ImageIcon(AssetImage("assets/launcher/ic_bell_2.png"),
                  color: Colors.red),
              icon: ImageIcon(AssetImage("assets/launcher/ic_bell_2.png"),
                  color: Colors.grey),
              title: Padding(
                padding: EdgeInsets.all(0),
                child: Text('Thông báo'),
              ),
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.menu, color: Colors.red),
              icon: Icon(Icons.menu, color: Colors.grey),
              title: Padding(
                padding: EdgeInsets.all(0),
                child: Text('Thêm'),
              ),
            )
          ],
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red,
          onTap: _onItemTapped,
        )
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
//              Fluttertoast.showToast(
//                  msg: europeanCountries[index],
//                  toastLength: Toast.LENGTH_SHORT,
//                  gravity: ToastGravity.BOTTOM,
//                  timeInSecForIosWeb: 1,
//                  backgroundColor: Colors.black45,
//                  textColor: Colors.white,
//                  fontSize: 16.0);
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
//    Fluttertoast.showToast(
//        msg: msg,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIosWeb: 1,
//        backgroundColor: Colors.black45,
//        textColor: Colors.white,
//        fontSize: 16.0);
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

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();

  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.orange.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Most\nFavorites",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "20 Items",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Newest",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "20 Items",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Super\nSaving",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "20 Items",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
