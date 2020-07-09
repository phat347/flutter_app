import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/loaders/color_loader_5.dart';
import 'package:flutterapp/loaders/dot_type.dart';
import 'package:flutterapp/models/Submission.dart';
import 'package:flutterapp/screens/DetailSubmission.dart';
import 'package:flutterapp/services/ApiService.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:logger/logger.dart';

import '../HattoColors.dart';

class SearchScreenWidget extends StatefulWidget {
  Logger logger = Logger();
  ApiService apiService = ApiService.create();

  @override
  _SearchScreenWidgetState createState() => _SearchScreenWidgetState();
}

class _SearchScreenWidgetState extends State<SearchScreenWidget> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin<SearchScreenWidget>{
  Future recommnederSubmissionFuture;
  List<Submission> listRecommenderSubmission = [];

  final GlobalKey<RefreshIndicatorState> submissionTagKey2 =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    recommnederSubmissionFuture = getRecommenderSubmission();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    final double itemHeight = (orientation == Orientation.portrait)?(size.height)/3.4:(size.height) / 2.6;
    final double itemWidth = (orientation == Orientation.portrait)?size.width / 2:size.width/3;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getRecommenderSubmission,
          child: FutureBuilder(
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
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                        crossAxisSpacing: 0,
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 3,
                        childAspectRatio: (orientation == Orientation.portrait)
                            ? (itemWidth / itemHeight)
                            : (itemHeight / 125)),
                    key: PageStorageKey(submissionTagKey2),
                    itemCount: listRecommenderSubmission.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var itemSub = listRecommenderSubmission[index];

                      return FocusedMenuHolder(
                        menuWidth: MediaQuery.of(context).size.width*0.50,
                        blurSize: 5.0,
                        menuItemExtent: 45,

                        duration: Duration(milliseconds: 100),
                        animateMenuItems: true,
                        blurBackgroundColor: Colors.black54,
                        bottomOffsetHeight: 100,
                        menuItems: <FocusedMenuItem>[
                          FocusedMenuItem(title: Text("Mở"),trailingIcon: Icon(Icons.open_in_new) ,onPressed: (){
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        DetailSubmission(itemSub, index)))
                                .then((value) {
                              if (value != null) {
                                Submission itemsDetailBack = value as Submission;
                                setState(() {
                                  listRecommenderSubmission[index] = itemsDetailBack;
//                                            itemSub = itemsDetailBack;
                                });
                              }
                            });
                          }),
                          FocusedMenuItem(title: Text("Chia sẻ"),trailingIcon: Icon(Icons.share) ,onPressed: (){}),
                          FocusedMenuItem(title: Text("Yêu thích"),trailingIcon: Icon(Icons.favorite_border) ,onPressed: (){}),
                          FocusedMenuItem(title: Text("Bỏ",style: TextStyle(color: Colors.white),),trailingIcon: Icon(Icons.delete,color: Colors.white,) ,onPressed: (){
                            setState(() {
                              listRecommenderSubmission.removeAt(index);
                            });
                          },backgroundColor: Colors.redAccent),
                        ],
                        onPressed: (){
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      DetailSubmission(itemSub, index)))
                              .then((value) {
                            if (value != null) {
                              Submission itemsDetailBack = value as Submission;
                              setState(() {
                                listRecommenderSubmission[index] = itemsDetailBack;
//                                            itemSub = itemsDetailBack;
                              });
                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Container(
                            width: itemWidth,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withAlpha(100),
                                      blurRadius: 10.0),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                        width: itemWidth,
                                        height: (orientation == Orientation.portrait)?itemHeight-55:itemHeight,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                  itemSub.URL_img_id)),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
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
                                      width: itemWidth,
                                      height: (orientation == Orientation.portrait)?itemHeight-55:itemHeight,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 100,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                  HattoColors.gradientBlackStart,
                                                  HattoColors.gradientBlackEnd
                                                ])),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: (orientation == Orientation.portrait)?itemHeight-55:itemHeight,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/prediction.png",
                                                          color: Colors.white,
                                                          width: 18,
                                                          height: 18,
                                                        ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            "${itemSub.i_found + itemSub.NUM_MATCHES}",
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    "RobotoMedium",
                                                                color:
                                                                    Colors.white),
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
                                                          color: Colors.white,
                                                          width: 18,
                                                          height: 18,
                                                        ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            "${itemSub.total_unique_views}",
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    "RobotoMedium",
                                                                color:
                                                                    Colors.white),
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
                                                            MainAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            child: Center(
                                                              child: Container(
                                                                child: Image.asset(
                                                                    "assets/images/ic_bike_delivery_2x.png",
                                                                    width: 15,
                                                                    height: 15),
                                                              ),
                                                            ),
                                                            width: 18,
                                                            height: 18,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                                color:
                                                                    Colors.white),
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
                                SizedBox(height: 3,),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            itemSub.class_desc,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "RobotoMedium",
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
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: itemSub.isVipCheck()
                                                        ? HattoColors.colorPrimary
                                                        : Colors.black,
                                                    fontFamily: "RobotoMedium",
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
