import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/Utils/AppUtils.dart';
import 'package:flutterapp/current_user.dart';
import 'package:flutterapp/famous_group.dart';
import 'package:flutterapp/list_submission.dart';
import 'package:flutterapp/loaders/LoadMoreCustom.dart';
import 'package:flutterapp/loaders/color_loader_3.dart';
import 'package:flutterapp/loaders/color_loader_5.dart';
import 'package:flutterapp/loaders/dot_type.dart';
import 'package:flutterapp/models/FamousGroup.dart';
import 'package:flutterapp/models/SelecteDistance.dart';
import 'package:flutterapp/models/Submission.dart';
import 'package:flutterapp/models/User.dart';
import 'package:flutterapp/rank_master.dart';
import 'package:flutterapp/recipe_search.dart';
import 'package:flutterapp/screens/DetailSubmission.dart';
import 'package:flutterapp/screens/GalleryPhotoZoom.dart';
import 'package:flutterapp/screens/HomeWidget.dart';
import 'package:flutterapp/select_distance.dart';
import 'package:flutterapp/services/ApiService.dart';
import 'package:flutterapp/services/CustomProxy.dart';
import 'package:flutterapp/widgets/dialogs/CustomDialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'HattoColors.dart';
import 'models/RecipeSearch.dart';

void main() {
  //Nếu bắt Charles thì bật
//  if (!kReleaseMode) {
//    // For Android devices you can also allowBadCertificates: true below, but you should ONLY do this when !kReleaseMode
//    final proxy = CustomProxy(
//        ipAddress: "192.168.16.44", port: 8888, allowBadCertificates: false);
//    proxy.enable();
//  }
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
        fontFamily: 'Roboto',
        primarySwatch: Colors.red,
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  Logger logger = Logger();

  ApiService apiService = ApiService.create();


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

  bool isVisibleBottomBar;
  int countNotification = 99;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();

    isVisibleBottomBar = true;


  }

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  widgetHomecallback(booleanCallback) {
    setState(() {
      isVisibleBottomBar = booleanCallback;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
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
    print("setState _MyHomePageState");
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget> [
          HomeWidget(widgetHomecallback),
          Scaffold(body: Container(child: Center(child: Text("Search Scaffold")),),),
          Scaffold(),
          Scaffold(body: Container(child: Center(child: Text("Notification Scaffold")),),),
          Scaffold(body: Container(child: Center(child: Text("MENU Scaffold")),),),
        ],
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: isVisibleBottomBar ? 56.0 : 0.0,
        child: Wrap(
          children: [
            Stack(
              children: [
                BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      activeIcon: ImageIcon(
                          AssetImage("assets/images/combinedshape.png"),
                          color: HattoColors.colorPrimary),
                      icon: ImageIcon(
                          AssetImage("assets/images/combinedshape.png"),
                          color: Colors.grey),
                      title: Padding(
                        padding: EdgeInsets.all(0),
                        child: Text('Trang chủ'),
                      ),
                    ),
                    BottomNavigationBarItem(
                      activeIcon: ImageIcon(
                          AssetImage("assets/images/ic_search.png"),
                          color: HattoColors.colorPrimary),
                      icon: ImageIcon(AssetImage("assets/images/ic_search.png"),
                          color: Colors.grey),
                      title: Padding(
                        padding: EdgeInsets.all(0),
                        child: Text('Tìm kiếm'),
                      ),
                    ),
                    BottomNavigationBarItem(
                      activeIcon:
                          Icon(Icons.camera, color: HattoColors.colorPrimary),
                      icon: Icon(Icons.camera, color: Colors.white),
                      title: Padding(
                        padding: EdgeInsets.all(0),
                        child: Text(''),
                      ),
                    ),
                    BottomNavigationBarItem(
                      activeIcon: ImageIcon(
                          AssetImage("assets/images/ic_bell_2.png"),
                          color: HattoColors.colorPrimary),
                      icon: Stack(children: [
                        ImageIcon(AssetImage("assets/images/ic_bell_2.png"),
                            color: Colors.grey),
                        Visibility(
                          visible: countNotification > 0 ? true : false,
                          child: Positioned(
                            right: 0,
                            child: new Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 3),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: new Text(
                                '$countNotification',
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'RobotoRegular',
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ]),
                      title: Padding(
                        padding: EdgeInsets.all(0),
                        child: Text('Thông báo'),
                      ),
                    ),
                    BottomNavigationBarItem(
                      activeIcon:
                          Icon(Icons.menu, color: HattoColors.colorPrimary),
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
                  selectedItemColor: HattoColors.colorPrimary,
                  onTap: _onItemTapped,
                ),
                BottomCameraWidget()
              ],
            ),
          ],
        ),
      ),
    );
  }


}

class BottomCameraWidget extends StatefulWidget {
  bool flagOpenCamera = true;

  @override
  _BottomCameraWidgetState createState() => _BottomCameraWidgetState();
}

class _BottomCameraWidgetState extends State<BottomCameraWidget> {
  @override
  void initState() {
    // TODO: implement initState

    print('Khởi tạo onCreate BottomCameraWidget');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('setState build BottomCameraWidget');

    return Container(
      height: kBottomNavigationBarHeight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              bool shouldUpdate;
              setState(() {
                widget.flagOpenCamera = !widget.flagOpenCamera;
              });

              if (!widget.flagOpenCamera) {
                shouldUpdate = await showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogs(
                        title: "Đây là test thôi :D",
                        description: "Đây là app Hatto viết bằng Flutter!",
                        buttonText: "Đóng",
                      );
                    });
              }

              if (shouldUpdate) {
                setState(() {
                  widget.flagOpenCamera = shouldUpdate;
                });
              }
            },
            child: Container(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: HattoColors.colorPrimary,
                    boxShadow: [
                      BoxShadow(
                          color: HattoColors.colorPrimary.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 5),
                    ]),
                child: widget.flagOpenCamera
                    ? Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/ic_nav_camera.png",
                          width: 20,
                          height: 20,
                        ))
                    : Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/ic_close_light.png",
                          width: 18,
                          height: 18,
                        )),
              ),
              width: 80,
              alignment: Alignment.center,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
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
