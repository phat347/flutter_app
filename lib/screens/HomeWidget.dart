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
import 'package:flutterapp/models/RecipeSearch.dart';
import 'package:flutterapp/models/SelecteDistance.dart';
import 'package:flutterapp/models/Submission.dart';
import 'package:flutterapp/models/User.dart';
import 'package:flutterapp/rank_master.dart';
import 'package:flutterapp/recipe_search.dart';
import 'package:flutterapp/screens/DetailSubmission.dart';
import 'package:flutterapp/screens/GalleryPhotoZoom.dart';
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
import 'package:provider/provider.dart';

import '../HattoColors.dart';

class HomeWidget extends StatefulWidget {
  Logger logger = Logger();
  ApiService apiService = ApiService.create();

  Function(bool) callback;

  HomeWidget(this.callback);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<HomeWidget> {
  TabController tabBarController;
  bool closeTopContainer = false;
  double topContainer = 0;

  bool flagLoadmore = false;

  List<Submission> listSpecialSubmission = [];
  List<Submission> listSubmission = [];

  List<Submission> listRecommenderSubmission = [];

  List<dynamic> rank = rank_master;
  List<SelectDistance> listSelectDistance = [];
  List<RecipeSearch> listRecipeSearch = [];
  List<FamousGroup> listFamousGroup = [];

  User mCurrentUser;

  int indexSelectedDistance = 0;
  SelectDistance selectedItem;

  Future specialSubmissionFuture;
  Future submissionFuture;

  Future recommnederSubmissionFuture;

  int countNotification = 99;

  String trendy_url =
      "https://hatto.net/trendy/TRENDY_1585242157_5664e7c8-37df-41ce-bce0-2ec826ba2d2e.png";

  final GlobalKey<RefreshIndicatorState> submissionTagKey =
      new GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> locationTabKey =
      new GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> specialTabKey =
      new GlobalKey<RefreshIndicatorState>();

  int _selectedIndex = 0;

  bool isSwitched = true;

  void _onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  String getRankIcon(int rankId) {
    List<String> rankIcon = [];
    rank.forEach((element) {
      rankIcon.add(element["icon_url"]);
    });
    return rankIcon[rankId];
  }

  void _handleTabSelection() {
    setState(() {
      isVisibleBottomBar = true;
      widget.callback(isVisibleBottomBar);
    });
  }

  void getSelectDistanceList() {
    List<Map<String, Object>> json_data = select_distance;
    listSelectDistance = json_data
        .map((json_data) => SelectDistance.fromJson(json_data))
        .toList();
    selectedItem = listSelectDistance[0];
  }

  void getRecipeSearchList() {
    List<Map<String, Object>> json_data = recipe_search;
    listRecipeSearch =
        json_data.map((json_data) => RecipeSearch.fromJson(json_data)).toList();
    listRecipeSearch[0].setSelected = true;
  }

  void getFamousGroup() {
    List<Map<String, Object>> json_data = famous_group;
    listFamousGroup =
        json_data.map((json_data) => FamousGroup.fromJson(json_data)).toList();
    listFamousGroup[0].setSelected = true;
  }

  void getCurrentUser() {
    Map<String, Object> json_data = current_user;
    mCurrentUser = User.fromJson(json_data);
  }

  ScrollController hideBottomBarScrollController1;
  ScrollController hideBottomBarScrollController2;
  ScrollController hideBottomBarScrollController3;
  bool isVisibleBottomBar;

  @override
  void initState() {
    super.initState();
    getSelectDistanceList();
    getRecipeSearchList();
    getCurrentUser();
    getFamousGroup();

    specialSubmissionFuture = getListSpecialSubmission();
    submissionFuture = getListSubmission();
    recommnederSubmissionFuture = getRecommenderSubmission();
    tabBarController =
        new TabController(initialIndex: 1, length: 3, vsync: this);
    tabBarController.addListener(_handleTabSelection);

    isVisibleBottomBar = true;

    hideBottomBarScrollController1 = ScrollController();
    hideBottomBarScrollController2 = ScrollController();
    hideBottomBarScrollController3 = ScrollController();

    hideBottomBarScrollController1.addListener(() {
      if (hideBottomBarScrollController1.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisibleBottomBar)
          setState(() {
            isVisibleBottomBar = false;
            widget.callback(isVisibleBottomBar);
          });
      }
      if (hideBottomBarScrollController1.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!isVisibleBottomBar)
          setState(() {
            isVisibleBottomBar = true;
            widget.callback(isVisibleBottomBar);
          });
      }
    });

    hideBottomBarScrollController2.addListener(() {
      if (hideBottomBarScrollController2.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisibleBottomBar)
          setState(() {
            isVisibleBottomBar = false;
            widget.callback(isVisibleBottomBar);
          });
      }
      if (hideBottomBarScrollController2.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!isVisibleBottomBar)
          setState(() {
            isVisibleBottomBar = true;
            widget.callback(isVisibleBottomBar);
          });
      }
    });

    hideBottomBarScrollController3.addListener(() {
      if (hideBottomBarScrollController3.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisibleBottomBar)
          setState(() {
            isVisibleBottomBar = false;
            widget.callback(isVisibleBottomBar);
          });
      }
      if (hideBottomBarScrollController3.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!isVisibleBottomBar)
          setState(() {
            isVisibleBottomBar = true;
            widget.callback(isVisibleBottomBar);
          });
      }
    });
  }

  Future<List<Submission>> getListSubmission() async {
    await widget.apiService.getListSubmission().then((submissionItem) {
      widget.logger.i(submissionItem);
      setState(() {
        listSubmission = submissionItem;
      });
    });
    return listSubmission;
  }

  Future<List<Submission>> getListSpecialSubmission() async {
    await widget.apiService.getListSpecialSubmission().then((submissionItem) {
      widget.logger.i(submissionItem);
      setState(() {
        listSpecialSubmission = submissionItem;
      });
    });
    return listSpecialSubmission;
  }

  Future<List<Submission>> getRecommenderSubmission() async {
    await widget.apiService.getRecommenderSubmission().then((submissionItem) {
      widget.logger.i(submissionItem);
      setState(() {
        listRecommenderSubmission = submissionItem;
      });
    });
    return listRecommenderSubmission;
  }

  Future<List<Submission>> getRecommenderSubmissionDistance() async {
    await widget.apiService
        .getRecommenderSubmissionDistance()
        .then((submissionItem) {
      widget.logger.i(submissionItem);
      setState(() {
        listRecommenderSubmission = submissionItem;
      });
    });
    return listRecommenderSubmission;
  }

  Future<bool> loadMoreSubmission() async {
    await widget.apiService.getListSpecialSubmission().then((submissionItem) {
      widget.logger.i(submissionItem);
      setState(() {
        listSubmission.addAll(submissionItem);
      });
    });
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabBarController.dispose();
    hideBottomBarScrollController1.dispose();
    hideBottomBarScrollController2.dispose();
    hideBottomBarScrollController3.dispose();
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

  CircleAvatar getAvatarUser(Submission items, double size) {
    if (!items.isVipCheck()) {
      return CircleAvatar(
          radius: size,
          backgroundImage: CachedNetworkImageProvider(items.portrait_url),
          backgroundColor: Colors.transparent);
    } else {
      return CircleAvatar(
          radius: size,
          child: CircleAvatar(
              radius: size - 1,
              backgroundImage: CachedNetworkImageProvider(items.portrait_url),
              backgroundColor: Colors.transparent),
          backgroundColor: HattoColors.colorPrimary);
    }
  }

  CircleAvatar getCurrentAvatarUser(User user, double size) {
    if (!user.isVipCheck()) {
      return CircleAvatar(
          radius: size,
          backgroundImage: CachedNetworkImageProvider(user.portrait_url),
          backgroundColor: Colors.transparent);
    } else {
      return CircleAvatar(
          radius: size,
          child: CircleAvatar(
              radius: size - 1,
              backgroundImage: CachedNetworkImageProvider(user.portrait_url),
              backgroundColor: Colors.transparent),
          backgroundColor: HattoColors.colorPrimary);
    }
  }

  CircleAvatar getAvatarLocation(Submission items) {
    if (items.location_ownership != 0) {
      return CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage("assets/images/ic_stamp_geniune.png"),
          backgroundColor: Colors.transparent);
    } else {
      return CircleAvatar(
          radius: 18,
          backgroundImage:
              CachedNetworkImageProvider(items.location_img_header_url),
          backgroundColor: Colors.transparent);
    }
  }

  Container ContainerRecommenderSubmission() => Container(
        color: HattoColors.colorPrimary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/prediction.png",
                    color: Colors.white,
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: RichText(
                        text: TextSpan(
                            text: "Hatto-AI gợi ý ",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'RobotoMedium',
                                color: Colors.white),
                            children: <TextSpan>[
                          TextSpan(
                              text: "chiều nay".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'RobotoBold',
                                  color: Colors.yellow)),
                          TextSpan(
                              text: " bạn nên ăn gì?",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'RobotoMedium',
                                  color: Colors.white))
                        ])),
                  )
                ],
              ),
            ),
            FutureBuilder(
              future: recommnederSubmissionFuture,
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
                  return SizedBox(
                    height: 240,
                    child: ListView.builder(
                        key: PageStorageKey(submissionTagKey),
                        scrollDirection: Axis.horizontal,
                        itemCount: listRecommenderSubmission.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var itemSub = listRecommenderSubmission[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              DetailSubmission(itemSub, index)))
                                  .then((value) {
                                if (value != null) {
                                  Submission itemsDetailBack =
                                      value as Submission;
                                  setState(() {
                                    listRecommenderSubmission[index] =
                                        itemsDetailBack;
//                                            itemSub = itemsDetailBack;
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width: 170,
                                height: 240,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                            width: 170,
                                            height: 197,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          itemSub.URL_img_id)),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                            )),
                                        Positioned(
                                            child: Image.asset(
                                                "assets/images/ic_rectangle_green.png",
                                                width: 30,
                                                height: 40),
                                            left: 10),
                                        Positioned(
                                          child: Image.asset(
                                              "assets/images/ic_buaan.png",
                                              width: 18,
                                              height: 18,
                                              color: Colors.white),
                                          left: 16,
                                          top: 10,
                                        ),
                                        Container(
                                          height: 197,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 100,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                      HattoColors
                                                          .gradientBlackStart,
                                                      HattoColors
                                                          .gradientBlackEnd
                                                    ])),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 197,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              child: Container(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/prediction.png",
                                                              color:
                                                                  Colors.white,
                                                              width: 18,
                                                              height: 18,
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                "${itemSub.i_found + itemSub.NUM_MATCHES}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        "RobotoMedium",
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/ic_eye_pass_active.png",
                                                              color:
                                                                  Colors.white,
                                                              width: 18,
                                                              height: 18,
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                "${itemSub.total_unique_views}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        "RobotoMedium",
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            itemSub.location_home_delivery !=
                                                                    0
                                                                ? true
                                                                : false,
                                                        child: Flexible(
                                                          flex: 1,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                child: Center(
                                                                  child:
                                                                      Container(
                                                                    child: Image.asset(
                                                                        "assets/images/ic_bike_delivery_2x.png",
                                                                        width:
                                                                            15,
                                                                        height:
                                                                            15),
                                                                  ),
                                                                ),
                                                                width: 18,
                                                                height: 18,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: SizedBox(
                                          height: 43,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  itemSub.class_desc,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          "RobotoMedium",
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  getAvatarUser(itemSub, 10),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      itemSub.user_name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: itemSub
                                                                  .isVipCheck()
                                                              ? HattoColors
                                                                  .colorPrimary
                                                              : Colors.black,
                                                          fontFamily:
                                                              "RobotoMedium",
                                                          fontSize: 13),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bạn muốn chọn buổi ăn khác?",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontFamily: "RobotoRegular"),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 22,
                  )
                ],
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    selectedItem = Provider.of<SelectDistance>(context, listen: false);
    print("setState HomeWidget");
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            "assets/images/ic_chat_hatto.png",
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Tán gẫu",
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 22),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: HattoColors.veryLightPink),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${mCurrentUser.remain_GAO}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'RobotoItalic',
                                        color: HattoColors.colorPrimary),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    "assets/images/ic_plus.png",
                                    color: HattoColors.colorPrimary,
                                    width: 15,
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            left: 18,
                            child: Image.asset(
                              "assets/images/ic_rice.png",
                              width: 25,
                              height: 25,
                            ))
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 4, right: 22),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: HattoColors.veryLightPink),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${mCurrentUser.rewards}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'RobotoItalic',
                                        color: HattoColors.colorPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            child: Image.asset(
                          "assets/images/ic_dua.png",
                          width: 25,
                          height: 25,
                        ))
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 1, child: getCurrentAvatarUser(mCurrentUser, 15))
                ],
                mainAxisSize: MainAxisSize.max,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width,
              height: 1,
              color: HattoColors.greyD3,
            )
          ],
        ),
        brightness: Brightness.light,
        bottom: TabBar(
          controller: tabBarController,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 35.0,
            indicatorColor: HattoColors.colorPrimary,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          isScrollable: true,
          indicatorColor: HattoColors.colorPrimary,
          labelColor: Colors.white,
          unselectedLabelColor: HattoColors.colorTimeLine,
          tabs: [
            Tab(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/ic_tab_special_black.png",
                    color: tabBarController.index == 0
                        ? Colors.white
                        : HattoColors.colorTimeLine,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Đặc sắc  ".toUpperCase(),
                    style: TextStyle(fontFamily: "RobotoBold", fontSize: 14),
                  )
                ],
              ),
            ),
            Tab(
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/ic_tab_submission_black.png",
                    color: tabBarController.index == 1
                        ? Colors.white
                        : HattoColors.colorTimeLine,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Món ăn  ".toUpperCase(),
                    style: TextStyle(fontFamily: "RobotoBold", fontSize: 14),
                  )
                ],
              ),
            ),
            Tab(
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/ic_tab_location_black.png",
                    color: tabBarController.index == 2
                        ? Colors.white
                        : HattoColors.colorTimeLine,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Địa điểm  ".toUpperCase(),
                    style: TextStyle(fontFamily: "RobotoBold", fontSize: 14),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: tabBarController,
        children: [
          RefreshIndicator(
            key: PageStorageKey(specialTabKey),
            onRefresh: getListSpecialSubmission,
            child: FutureBuilder(
                future: specialSubmissionFuture,
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
                          Container(
                            width: size.width,
                            height: 1,
                            color: HattoColors.greyD3,
                          ),
                          Container(
                            color: Colors.white,
                            width: size.width,
                            height: 50,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: listFamousGroup.length,
                                itemBuilder: (context, index) {
                                  FamousGroup item = listFamousGroup[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        for (FamousGroup r_items
                                            in listFamousGroup) {
                                          r_items.setSelected = false;
                                        }
                                        listFamousGroup[index].setSelected =
                                            true;
                                      });
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              item.icon_url)),
                                                )),
                                            Text(
                                              item.group_name ?? '',
                                              style: TextStyle(
                                                  fontFamily: 'RobotoBold',
                                                  fontSize: 14,
                                                  color: item.selected
                                                      ? HattoColors.colorPrimary
                                                      : Colors.black
                                                          .withOpacity(0.6)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          Container(
                            height: 30,
                            color: Colors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: Text(
                                        "Từ khóa thông dụng",
                                        style: TextStyle(
                                            fontFamily: 'RobotoBold',
                                            fontSize: 14,
                                            color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                  Flexible(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            enableDrag: true,
                                            context: context,
                                            builder: (context) {
                                              return SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ClipRRect(
                                                          child: Column(
                                                            children: [
                                                              ...listSelectDistance
                                                                  .map((e) =>
                                                                      Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            GestureDetector(
                                                                              child: Container(
                                                                                  decoration: BoxDecoration(color: Colors.white),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        e.name,
                                                                                        style: TextStyle(fontSize: 15, fontFamily: 'RobotoRegular'),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  width: size.width),
                                                                              onTap: () {
                                                                                getRecommenderSubmissionDistance();
                                                                                selectedItem.setSelectedDistance(e);
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                            Container(
                                                                              height: 1,
                                                                              color: HattoColors.greyD3,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      ClipRRect(
                                                        child: GestureDetector(
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .white),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Hủy bỏ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontFamily:
                                                                            'RobotoRegular'),
                                                                  ),
                                                                ),
                                                              ),
                                                              width:
                                                                  size.width),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: HattoColors.greyD3),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: ChangeNotifierProvider<
                                                    SelectDistance>.value(
                                                  value: selectedItem,
                                                  child:
                                                      Consumer<SelectDistance>(
                                                    builder: (context, data,
                                                            child) =>
                                                        Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          data.name,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "RobotoBold",
                                                              fontSize: 12,
                                                              color: HattoColors
                                                                  .colorPrimary),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: HattoColors
                                                              .colorPrimary,
                                                          size: 15,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                                  controller: hideBottomBarScrollController1,
                                  itemCount: listSpecialSubmission.length + 1,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var itemSub;
                                    if (index != 0) {
                                      itemSub =
                                          listSpecialSubmission[index - 1];
                                    }
                                    if (index == 0) {
                                      return GestureDetector(
                                        onTap: () {
                                          List<String> url = [];
                                          url.add(trendy_url);
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      GalleryPhotoZoom(url)));
                                        },
                                        child: Container(
                                            height: 200,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          trendy_url)),
                                            )),
                                      );
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailSubmission(
                                                            itemSub, index)))
                                            .then((value) {
                                          if (value != null) {
                                            Submission itemsDetailBack =
                                                value as Submission;
                                            setState(() {
                                              listSpecialSubmission[index - 1] =
                                                  itemsDetailBack;
//                                            itemSub = itemsDetailBack;
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(100),
                                                    blurRadius: 10.0),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            child: Column(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Hero(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                          height: 300,
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: CachedNetworkImageProvider(
                                                                    itemSub
                                                                        .URL_img_id)),
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10.0)),
                                                          )),
                                                      Positioned(
                                                          child: Image.asset(
                                                              "assets/images/ic_rectangle_green.png",
                                                              width: 35,
                                                              height: 45),
                                                          left: 10),
                                                      Positioned(
                                                        child: Image.asset(
                                                            "assets/images/ic_buaan.png",
                                                            width: 20,
                                                            height: 20,
                                                            color:
                                                                Colors.white),
                                                        left: 17.5,
                                                        top: 10,
                                                      )
                                                    ],
                                                  ),
                                                  tag: index.toString() +
                                                      itemSub.forum_id,
                                                ),
                                                SizedBox(width: 10),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
//                                                mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Row(
//                                                    crossAxisAlignment:
//                                                        CrossAxisAlignment
//                                                            .start,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Hero(
                                                              tag: index
                                                                      .toString() +
                                                                  itemSub
                                                                      .portrait_url,
                                                              child:
                                                                  getAvatarUser(
                                                                      itemSub,
                                                                      20)),
                                                          SizedBox(width: 5),
                                                          Flexible(
                                                            child: Container(
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Text(
                                                                              itemSub.user_name,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: TextStyle(fontSize: 15, fontFamily: 'RobotoMedium', color: !itemSub.isVipCheck() ? Colors.black : HattoColors.colorPrimary),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              AppUtils.formatNumber(itemSub.remain_rewards),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: TextStyle(fontSize: 15, fontFamily: 'RobotoMedium', color: HattoColors.colorPrimary),
                                                                            ),
                                                                            SizedBox(width: 1),
                                                                            Container(
                                                                                width: 15,
                                                                                height: 15,
                                                                                child: Image.asset("assets/images/ic_dua.png"))
                                                                          ],
                                                                        ),
                                                                      ],
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Visibility(
                                                                          visible: !itemSub.isVipCheck()
                                                                              ? false
                                                                              : true,
                                                                          child: Container(
                                                                              decoration: new BoxDecoration(color: HattoColors.colorPrimary, borderRadius: new BorderRadius.all(Radius.circular(8))),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Super VIP".toUpperCase(),
                                                                                    style: TextStyle(fontSize: 7, fontFamily: 'RobotoBold', color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                3),
                                                                        Container(
                                                                            height:
                                                                                15,
                                                                            width:
                                                                                15,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(getRankIcon(itemSub.rank_id))),
                                                                            )),
                                                                        SizedBox(
                                                                            width:
                                                                                3),
                                                                        Text(
                                                                          itemSub
                                                                              .rank_desc,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              fontFamily: 'RobotoRegular',
                                                                              color: HattoColors.colorTimeLine),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ]),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        itemSub.class_desc,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'RobotoMedium',
                                                            fontSize: 20),
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            itemSub.location_name !=
                                                                    null
                                                                ? true
                                                                : false,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 2),
                                                          child: Row(
//                                                    crossAxisAlignment:
//                                                        CrossAxisAlignment
//                                                            .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              getAvatarLocation(
                                                                  itemSub),
                                                              SizedBox(
                                                                  width: 5),
                                                              Flexible(
                                                                child:
                                                                    Container(
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: Container(
                                                                                child: Text(
                                                                                  itemSub.location_name ?? "",
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                  style: TextStyle(fontSize: 12, fontFamily: 'RobotoMedium', color: Colors.black),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Visibility(
                                                                              visible: itemSub.location_home_delivery != 0 ? true : false,
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(width: 15, height: 15, child: Image.asset("assets/images/ic_bike_delivery_2x.png")),
                                                                                  SizedBox(width: 1),
                                                                                  Text(
                                                                                    "Có giao hàng qua Hatto",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(fontSize: 11, fontFamily: 'RobotoMedium', color: Colors.black),
                                                                                  ),
                                                                                ],
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Flexible(
                                                                              child: Text(
                                                                                itemSub.location_address ?? "",
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 2,
                                                                                style: TextStyle(fontSize: 11, fontFamily: 'RobotoRegular', color: HattoColors.colorTimeLine),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ]),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        itemSub.extra_desc,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'RobotoRegular',
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    "assets/images/ic_clock.png",
                                                                    width: 10,
                                                                    height: 10),
                                                                SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                  AppUtils.getDateTimeAgo(
                                                                      itemSub
                                                                          .timestamp),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'RobotoRegular',
                                                                      color: HattoColors
                                                                          .colorTimeLine),
                                                                ),
                                                                SizedBox(
                                                                    width: 5),
                                                                AppUtils.getSharingOptionIcon(
                                                                    itemSub
                                                                        .sharing_option,
                                                                    10,
                                                                    10)
                                                              ],
                                                            ),
                                                          ),
                                                          Flexible(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              RichText(
                                                                  text: TextSpan(
                                                                      text: itemSub
                                                                          .total_unique_views
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              'RobotoBold',
                                                                          color: Colors
                                                                              .black),
                                                                      children: <
                                                                          TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            " lượt xem",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'RobotoRegular',
                                                                            color:
                                                                                HattoColors.colorTimeLine.withOpacity(0.7))),
                                                                  ])),
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/emote_clap.png",
                                                                          width:
                                                                              16,
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Flexible(
                                                                          child: Text(
                                                                              itemSub.voted_id_1.toString(),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontSize: 12, fontFamily: 'RobotoMedium', color: Colors.black)),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Flexible(
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/emote_rose.png",
                                                                          width:
                                                                              16,
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Flexible(
                                                                          child: Text(
                                                                              itemSub.voted_id_2.toString(),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontSize: 12, fontFamily: 'RobotoMedium', color: Colors.black)),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Flexible(
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/emote_suprise.png",
                                                                          width:
                                                                              16,
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Text(
                                                                            itemSub
                                                                                .voted_id_3
                                                                                .toString(),
                                                                            maxLines:
                                                                                1,
                                                                            overflow: TextOverflow
                                                                                .ellipsis,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontFamily: 'RobotoMedium',
                                                                                color: Colors.black))
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Image.asset(
                                                                "assets/images/ic_favorite_2x.png",
                                                                width: 16,
                                                                height: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                  itemSub
                                                                      .favorite_count
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          'RobotoBold',
                                                                      color: Colors
                                                                          .black)),
                                                              SizedBox(
                                                                  width: 5),
                                                              Image.asset(
                                                                "assets/images/ic_chat_2x.png",
                                                                width: 16,
                                                                height: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              RichText(
                                                                  text: TextSpan(
                                                                      text: itemSub
                                                                          .replies_count
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              'RobotoBold',
                                                                          color: Colors
                                                                              .black),
                                                                      children: <
                                                                          TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            " bình luận",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'RobotoRegular',
                                                                            color:
                                                                                HattoColors.colorTimeLine.withOpacity(0.7))),
                                                                  ])),
                                                            ],
                                                          ))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    );
                                  })),
                        ],
                      ),
                    );
                  }
                }),
          ),
          RefreshIndicator(
            key: PageStorageKey(submissionTagKey),
            onRefresh: () async {
              getRecommenderSubmission();
              await getListSubmission();
            },
            child: FutureBuilder(
                future: submissionFuture,
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
                          Container(
                            width: size.width,
                            height: 1,
                            color: HattoColors.greyD3,
                          ),
                          Container(
                            color: Colors.white,
                            width: size.width,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      Switch(
                                        value: isSwitched,
                                        activeColor: Colors.white,
                                        inactiveTrackColor: HattoColors.greyD3,
                                        inactiveThumbColor:
                                            HattoColors.whiteGrey92,
                                        activeTrackColor:
                                            HattoColors.greenLight,
                                        onChanged: (value) {
                                          setState(() {
                                            isSwitched = value;
                                          });
                                        },
                                      ),
                                      Flexible(
                                        child: Text(
                                          isSwitched
                                              ? "Tất cả bài viết"
                                              : "Bài của tôi",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontFamily: "RobotoRegular",
                                              fontSize: 13),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          enableDrag: true,
                                          context: context,
                                          builder: (context) {
                                            return SingleChildScrollView(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ClipRRect(
                                                        child: Column(
                                                          children: [
                                                            ...listSelectDistance
                                                                .map((e) =>
                                                                    Container(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          GestureDetector(
                                                                            child: Container(
                                                                                decoration: BoxDecoration(color: Colors.white),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      e.name,
                                                                                      style: TextStyle(fontSize: 15, fontFamily: 'RobotoRegular'),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                width: size.width),
                                                                            onTap:
                                                                                () {
                                                                              getRecommenderSubmissionDistance();
                                                                                selectedItem.setSelectedDistance(e);
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                1,
                                                                            color:
                                                                                HattoColors.greyD3,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ))
                                                                .toList(),
                                                          ],
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    ClipRRect(
                                                      child: GestureDetector(
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .white),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10),
                                                              child: Center(
                                                                child: Text(
                                                                  "Hủy bỏ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          'RobotoRegular'),
                                                                ),
                                                              ),
                                                            ),
                                                            width: size.width),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: HattoColors.greyD3),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ChangeNotifierProvider<SelectDistance>.value(
                                          value: selectedItem,
                                          child: Consumer<SelectDistance>(builder: (context,data,child){
                                            return Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    data.name,
                                                    style: TextStyle(
                                                        fontFamily: "RobotoBold",
                                                        fontSize: 12,
                                                        color: HattoColors
                                                            .colorPrimary),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: HattoColors.colorPrimary,
                                                  size: 15,
                                                )
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          "assets/images/ic_chopstick.png",
                                          width: 15,
                                          height: 15,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "Chia sẻ bài mới",
                                            style: TextStyle(
                                                fontFamily: "RobotoRegular",
                                                fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          "assets/images/ic_search.png",
                                          width: 15,
                                          height: 15,
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width,
                            height: 3,
                            color: HattoColors.greyD3,
                          ),
                          Container(
                            color: Colors.white,
                            width: size.width,
                            height: 50,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: listRecipeSearch.length,
                                itemBuilder: (context, index) {
                                  RecipeSearch item = listRecipeSearch[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        for (RecipeSearch r_items
                                            in listRecipeSearch) {
                                          r_items.setSelected = false;
                                        }
                                        listRecipeSearch[index].setSelected =
                                            true;
                                      });
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              item.icon_url)),
                                                )),
                                            Text(
                                              item.display,
                                              style: TextStyle(
                                                  fontFamily: 'RobotoBold',
                                                  fontSize: 14,
                                                  color: item.selected
                                                      ? HattoColors.colorPrimary
                                                      : Colors.black
                                                          .withOpacity(0.6)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          Expanded(
                              child: LoadMoreCustom(
                            onLoadMore: loadMoreSubmission,
                            textBuilder: DefaultLoadMoreTextBuilder.vietnam,
                            child: ListView.builder(
                                controller: hideBottomBarScrollController2,
                                itemCount: listSubmission.length + 1,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var itemSub;
                                  if (index != 0) {
                                    itemSub = listSubmission[index - 1];
                                  }

                                  if (index == 0) {
                                    return ContainerRecommenderSubmission();
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailSubmission(
                                                            itemSub, index)))
                                            .then((value) {
                                          if (value != null) {
                                            Submission itemsDetailBack =
                                                value as Submission;
                                            setState(() {
                                              listSubmission[index - 1] =
                                                  itemsDetailBack;
//                                            itemSub = itemsDetailBack;
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(100),
                                                    blurRadius: 10.0),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            child: Column(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Hero(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                          height: 300,
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: CachedNetworkImageProvider(
                                                                    itemSub
                                                                        .URL_img_id)),
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10.0)),
                                                          )),
                                                      Positioned(
                                                          child: Image.asset(
                                                              "assets/images/ic_rectangle_green.png",
                                                              width: 35,
                                                              height: 45),
                                                          left: 10),
                                                      Positioned(
                                                        child: Image.asset(
                                                            "assets/images/ic_buaan.png",
                                                            width: 20,
                                                            height: 20,
                                                            color:
                                                                Colors.white),
                                                        left: 17.5,
                                                        top: 10,
                                                      )
                                                    ],
                                                  ),
                                                  tag: index.toString() +
                                                      itemSub.forum_id,
                                                ),
                                                SizedBox(width: 10),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
//                                                mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Row(
//                                                    crossAxisAlignment:
//                                                        CrossAxisAlignment
//                                                            .start,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Hero(
                                                              tag: index
                                                                      .toString() +
                                                                  itemSub
                                                                      .portrait_url,
                                                              child:
                                                                  getAvatarUser(
                                                                      itemSub,
                                                                      20)),
                                                          SizedBox(width: 5),
                                                          Flexible(
                                                            child: Container(
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Text(
                                                                              itemSub.user_name,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: TextStyle(fontSize: 15, fontFamily: 'RobotoMedium', color: !itemSub.isVipCheck() ? Colors.black : HattoColors.colorPrimary),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              AppUtils.formatNumber(itemSub.remain_rewards),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: TextStyle(fontSize: 15, fontFamily: 'RobotoMedium', color: HattoColors.colorPrimary),
                                                                            ),
                                                                            SizedBox(width: 1),
                                                                            Container(
                                                                                width: 15,
                                                                                height: 15,
                                                                                child: Image.asset("assets/images/ic_dua.png"))
                                                                          ],
                                                                        ),
                                                                      ],
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Visibility(
                                                                          visible: !itemSub.isVipCheck()
                                                                              ? false
                                                                              : true,
                                                                          child: Container(
                                                                              decoration: new BoxDecoration(color: HattoColors.colorPrimary, borderRadius: new BorderRadius.all(Radius.circular(8))),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Super VIP".toUpperCase(),
                                                                                    style: TextStyle(fontSize: 7, fontFamily: 'RobotoBold', color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                3),
                                                                        Container(
                                                                            height:
                                                                                15,
                                                                            width:
                                                                                15,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(getRankIcon(itemSub.rank_id))),
                                                                            )),
                                                                        SizedBox(
                                                                            width:
                                                                                3),
                                                                        Text(
                                                                          itemSub
                                                                              .rank_desc,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              fontFamily: 'RobotoRegular',
                                                                              color: HattoColors.colorTimeLine),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ]),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        itemSub.class_desc,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'RobotoMedium',
                                                            fontSize: 20),
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            itemSub.location_name !=
                                                                    null
                                                                ? true
                                                                : false,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 2),
                                                          child: Row(
//                                                    crossAxisAlignment:
//                                                        CrossAxisAlignment
//                                                            .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              getAvatarLocation(
                                                                  itemSub),
                                                              SizedBox(
                                                                  width: 5),
                                                              Flexible(
                                                                child:
                                                                    Container(
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: Container(
                                                                                child: Text(
                                                                                  itemSub.location_name ?? "",
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                  style: TextStyle(fontSize: 12, fontFamily: 'RobotoMedium', color: Colors.black),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Visibility(
                                                                              visible: itemSub.location_home_delivery != 0 ? true : false,
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(width: 15, height: 15, child: Image.asset("assets/images/ic_bike_delivery_2x.png")),
                                                                                  SizedBox(width: 1),
                                                                                  Text(
                                                                                    "Có giao hàng qua Hatto",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(fontSize: 11, fontFamily: 'RobotoMedium', color: Colors.black),
                                                                                  ),
                                                                                ],
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Flexible(
                                                                              child: Text(
                                                                                itemSub.location_address ?? "",
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 2,
                                                                                style: TextStyle(fontSize: 11, fontFamily: 'RobotoRegular', color: HattoColors.colorTimeLine),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ]),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        itemSub.extra_desc,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'RobotoRegular',
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    "assets/images/ic_clock.png",
                                                                    width: 10,
                                                                    height: 10),
                                                                SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                  AppUtils.getDateTimeAgo(
                                                                      itemSub
                                                                          .timestamp),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'RobotoRegular',
                                                                      color: HattoColors
                                                                          .colorTimeLine),
                                                                ),
                                                                SizedBox(
                                                                    width: 5),
                                                                AppUtils.getSharingOptionIcon(
                                                                    itemSub
                                                                        .sharing_option,
                                                                    10,
                                                                    10)
                                                              ],
                                                            ),
                                                          ),
                                                          Flexible(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              RichText(
                                                                  text: TextSpan(
                                                                      text: itemSub
                                                                          .total_unique_views
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              'RobotoBold',
                                                                          color: Colors
                                                                              .black),
                                                                      children: <
                                                                          TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            " lượt xem",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'RobotoRegular',
                                                                            color:
                                                                                HattoColors.colorTimeLine.withOpacity(0.7))),
                                                                  ])),
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/emote_clap.png",
                                                                          width:
                                                                              16,
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Flexible(
                                                                          child: Text(
                                                                              itemSub.voted_id_1.toString(),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontSize: 12, fontFamily: 'RobotoMedium', color: Colors.black)),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Flexible(
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/emote_rose.png",
                                                                          width:
                                                                              16,
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Flexible(
                                                                          child: Text(
                                                                              itemSub.voted_id_2.toString(),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontSize: 12, fontFamily: 'RobotoMedium', color: Colors.black)),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Flexible(
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/emote_suprise.png",
                                                                          width:
                                                                              16,
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Text(
                                                                            itemSub
                                                                                .voted_id_3
                                                                                .toString(),
                                                                            maxLines:
                                                                                1,
                                                                            overflow: TextOverflow
                                                                                .ellipsis,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontFamily: 'RobotoMedium',
                                                                                color: Colors.black))
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Image.asset(
                                                                "assets/images/ic_favorite_2x.png",
                                                                width: 16,
                                                                height: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                  itemSub
                                                                      .favorite_count
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          'RobotoBold',
                                                                      color: Colors
                                                                          .black)),
                                                              SizedBox(
                                                                  width: 5),
                                                              Image.asset(
                                                                "assets/images/ic_chat_2x.png",
                                                                width: 16,
                                                                height: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              RichText(
                                                                  text: TextSpan(
                                                                      text: itemSub
                                                                          .replies_count
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              'RobotoBold',
                                                                          color: Colors
                                                                              .black),
                                                                      children: <
                                                                          TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            " bình luận",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'RobotoRegular',
                                                                            color:
                                                                                HattoColors.colorTimeLine.withOpacity(0.7))),
                                                                  ])),
                                                            ],
                                                          ))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    );
                                  }
                                }),
                          )),
                        ],
                      ),
                    );
                  }
                }),
          ),
          RefreshIndicator(
            key: PageStorageKey(locationTabKey),
            onRefresh: getListSpecialSubmission,
            child: FutureBuilder(
                future: specialSubmissionFuture,
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
                          Expanded(
                              child: ListView.builder(
                                  controller: hideBottomBarScrollController3,
                                  itemCount: listSpecialSubmission.length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var itemSub = listSpecialSubmission[index];
                                    double scale = 1.0;
                                    if (topContainer > 0.5) {
                                      scale = index + 0.5 - topContainer;
                                      if (scale < 0) {
                                        scale = 0;
                                      } else if (scale > 1) {
                                        scale = 1;
                                      }
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailSubmission(
                                                            itemSub, index)))
                                            .then((value) {
                                          if (value != null) {
                                            Submission itemsDetailBack =
                                                value as Submission;
                                            setState(() {
                                              listSpecialSubmission[index] =
                                                  itemsDetailBack;
//                                            itemSub = itemsDetailBack;
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(100),
                                                    blurRadius: 10.0),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            child: Column(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Hero(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                          height: 300,
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: CachedNetworkImageProvider(
                                                                    itemSub
                                                                        .URL_img_id)),
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10.0)),
                                                          )),
                                                      Positioned(
                                                          child: Image.asset(
                                                              "assets/images/ic_rectangle_green.png",
                                                              width: 35,
                                                              height: 45),
                                                          left: 10),
                                                      Positioned(
                                                        child: Image.asset(
                                                            "assets/images/ic_buaan.png",
                                                            width: 20,
                                                            height: 20,
                                                            color:
                                                                Colors.white),
                                                        left: 17.5,
                                                        top: 10,
                                                      )
                                                    ],
                                                  ),
                                                  tag: index.toString() +
                                                      itemSub.forum_id,
                                                ),
                                                SizedBox(width: 10),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
//                                                mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Row(
//                                                    crossAxisAlignment:
//                                                        CrossAxisAlignment
//                                                            .start,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Hero(
                                                              tag: index
                                                                      .toString() +
                                                                  itemSub
                                                                      .portrait_url,
                                                              child:
                                                                  getAvatarUser(
                                                                      itemSub,
                                                                      20)),
                                                          SizedBox(width: 5),
                                                          Flexible(
                                                            child: Container(
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Text(
                                                                              itemSub.user_name,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: TextStyle(fontSize: 15, fontFamily: 'RobotoMedium', color: !itemSub.isVipCheck() ? Colors.black : HattoColors.colorPrimary),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              AppUtils.formatNumber(itemSub.remain_rewards),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              style: TextStyle(fontSize: 15, fontFamily: 'RobotoMedium', color: HattoColors.colorPrimary),
                                                                            ),
                                                                            SizedBox(width: 1),
                                                                            Container(
                                                                                width: 15,
                                                                                height: 15,
                                                                                child: Image.asset("assets/images/ic_dua.png"))
                                                                          ],
                                                                        ),
                                                                      ],
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Visibility(
                                                                          visible: itemSub.isVipCheck()
                                                                              ? true
                                                                              : false,
                                                                          child: Container(
                                                                              decoration: new BoxDecoration(color: HattoColors.colorPrimary, borderRadius: new BorderRadius.all(Radius.circular(8))),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Super VIP".toUpperCase(),
                                                                                    style: TextStyle(fontSize: 7, fontFamily: 'RobotoBold', color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                3),
                                                                        Container(
                                                                            height:
                                                                                15,
                                                                            width:
                                                                                15,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(getRankIcon(itemSub.rank_id))),
                                                                            )),
                                                                        SizedBox(
                                                                            width:
                                                                                3),
                                                                        Text(
                                                                          itemSub
                                                                              .rank_desc,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              fontFamily: 'RobotoRegular',
                                                                              color: HattoColors.colorTimeLine),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ]),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        itemSub.class_desc,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'RobotoMedium',
                                                            fontSize: 20),
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            itemSub.location_name !=
                                                                    null
                                                                ? true
                                                                : false,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 2),
                                                          child: Row(
//                                                    crossAxisAlignment:
//                                                        CrossAxisAlignment
//                                                            .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              getAvatarLocation(
                                                                  itemSub),
                                                              SizedBox(
                                                                  width: 5),
                                                              Flexible(
                                                                child:
                                                                    Container(
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: Container(
                                                                                child: Text(
                                                                                  itemSub.location_name ?? "",
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                  style: TextStyle(fontSize: 12, fontFamily: 'RobotoMedium', color: Colors.black),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Visibility(
                                                                              visible: itemSub.location_home_delivery != 0 ? true : false,
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(width: 15, height: 15, child: Image.asset("assets/images/ic_bike_delivery_2x.png")),
                                                                                  SizedBox(width: 1),
                                                                                  Text(
                                                                                    "Có giao hàng qua Hatto",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(fontSize: 11, fontFamily: 'RobotoMedium', color: Colors.black),
                                                                                  ),
                                                                                ],
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Flexible(
                                                                              child: Text(
                                                                                itemSub.location_address ?? "",
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 2,
                                                                                style: TextStyle(fontSize: 11, fontFamily: 'RobotoRegular', color: HattoColors.colorTimeLine),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ]),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        itemSub.extra_desc,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'RobotoRegular',
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                    "assets/images/ic_clock.png",
                                                                    width: 10,
                                                                    height: 10),
                                                                SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                  AppUtils.getDateTimeAgo(
                                                                      itemSub
                                                                          .timestamp),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          'RobotoRegular',
                                                                      color: HattoColors
                                                                          .colorTimeLine),
                                                                ),
                                                                SizedBox(
                                                                    width: 5),
                                                                AppUtils.getSharingOptionIcon(
                                                                    itemSub
                                                                        .sharing_option,
                                                                    10,
                                                                    10)
                                                              ],
                                                            ),
                                                          ),
                                                          Flexible(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              RichText(
                                                                  text: TextSpan(
                                                                      text: itemSub
                                                                          .total_unique_views
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              'RobotoBold',
                                                                          color: Colors
                                                                              .black),
                                                                      children: <
                                                                          TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            " lượt xem",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'RobotoRegular',
                                                                            color:
                                                                                HattoColors.colorTimeLine.withOpacity(0.7))),
                                                                  ])),
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Flexible(
                                                            child: Container(
                                                              child: Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/emote_clap.png",
                                                                          width:
                                                                              16,
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Flexible(
                                                                          child: Text(
                                                                              itemSub.voted_id_1.toString(),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontSize: 12, fontFamily: 'RobotoMedium', color: Colors.black)),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Flexible(
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/emote_rose.png",
                                                                          width:
                                                                              16,
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Flexible(
                                                                          child: Text(
                                                                              itemSub.voted_id_2.toString(),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontSize: 12, fontFamily: 'RobotoMedium', color: Colors.black)),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Flexible(
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/images/emote_suprise.png",
                                                                          width:
                                                                              16,
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Text(
                                                                            itemSub
                                                                                .voted_id_3
                                                                                .toString(),
                                                                            maxLines:
                                                                                1,
                                                                            overflow: TextOverflow
                                                                                .ellipsis,
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontFamily: 'RobotoMedium',
                                                                                color: Colors.black))
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Image.asset(
                                                                "assets/images/ic_favorite_2x.png",
                                                                width: 16,
                                                                height: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                  itemSub
                                                                      .favorite_count
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          'RobotoBold',
                                                                      color: Colors
                                                                          .black)),
                                                              SizedBox(
                                                                  width: 5),
                                                              Image.asset(
                                                                "assets/images/ic_chat_2x.png",
                                                                width: 16,
                                                                height: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              RichText(
                                                                  text: TextSpan(
                                                                      text: itemSub
                                                                          .replies_count
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              'RobotoBold',
                                                                          color: Colors
                                                                              .black),
                                                                      children: <
                                                                          TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            " bình luận",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'RobotoRegular',
                                                                            color:
                                                                                HattoColors.colorTimeLine.withOpacity(0.7))),
                                                                  ])),
                                                            ],
                                                          ))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    );
                                  })),
                        ],
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: isVisibleBottomBar ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: SizedBox(
          width: 45.0,
          height: 45.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              switch (tabBarController.index) {
                case 0:
                  hideBottomBarScrollController1.animateTo(
                      hideBottomBarScrollController1.position.minScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300));
                  break;
                case 1:
                  hideBottomBarScrollController2.animateTo(
                      hideBottomBarScrollController2.position.minScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300));
                  break;
                case 2:
                  hideBottomBarScrollController3.animateTo(
                      hideBottomBarScrollController3.position.minScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300));
                  break;
              }

              Timer(Duration(milliseconds: 600), () {
                setState(() {
                  isVisibleBottomBar = true;
                  widget.callback(isVisibleBottomBar);
                });
              });
            },
            child: Icon(
              Icons.arrow_upward,
              color: HattoColors.colorPrimary,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
