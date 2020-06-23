import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/rendering.dart';
import 'package:flutterapp/HattoColors.dart';
import 'package:flutterapp/Utils/AppUtils.dart';
import 'package:flutterapp/models/Submission.dart';
import 'package:flutterapp/rank_master.dart';
import 'package:flutterapp/screens/GalleryPhotoZoom.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class DetailSubmission extends StatefulWidget {
  Submission items;
  int index;
  bool boxCommentTextChange = false;

  DetailSubmission(this.items, this.index);

  @override
  _DetailSubmissionState createState() => _DetailSubmissionState();
}

class _DetailSubmissionState extends State<DetailSubmission> {
  List<dynamic> rank = rank_master;

  TextEditingController boxCommentController;

  RefreshController _controller = RefreshController();

  @override
  void dispose() {
    // TODO: implement dispose
    boxCommentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    boxCommentController = TextEditingController();
    super.initState();
  }

  void voteFunction(int voteID) {
    setState(() {
      switch (voteID) {
        case 1:
          widget.items.voted_id_1++;
          break;
        case 2:
          widget.items.voted_id_2++;
          break;
        case 3:
          widget.items.voted_id_3++;
          break;
        case 4:
          widget.items.voted_id_4++;
          break;
        case 5:
          widget.items.voted_id_5++;
          break;
      }
    });
  }

  CircleAvatar getAvatarUser(Submission items) {
    if (items.isVipCheck()) {
      return CircleAvatar(
          radius: 20,
          backgroundImage: CachedNetworkImageProvider(items.portrait_url),
          backgroundColor: Colors.transparent);
    } else {
      return CircleAvatar(
          radius: 20,
          child: CircleAvatar(
              radius: 19,
              backgroundImage: CachedNetworkImageProvider(items.portrait_url),
              backgroundColor: Colors.transparent),
          backgroundColor: HattoColors.colorPrimary);
    }
  }

  String getRankIcon(int rankId) {
    List<String> rankIcon = [];
    rank.forEach((element) {
      rankIcon.add(element["icon_url"]);
    });
    return rankIcon[rankId];
  }

  Future<void> getSubItemDetail() async {
    var data_server = await http
        .get("https://next.json-generator.com/api/json/get/41TUyej6d");
    List<dynamic> json_data = jsonDecode(data_server.body);
    List<Submission> data =
    json_data.map((json_data) => Submission.fromJson(json_data)).toList();

    setState(() {
      widget.items = data[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Hero(
                  tag: widget.index.toString() + widget.items.portrait_url,
                  child: getAvatarUser(widget.items)),
              SizedBox(width: 5),
              Flexible(
                child: Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                child: Text(
                                  widget.items.user_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'RobotoMedium',
                                      color: widget.items.isVipCheck()
                                          ? Colors.black
                                          : HattoColors.colorPrimary),
                                ),
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Visibility(
                              visible: widget.items.isVipCheck() ? false : true,
                              child: Container(
                                  decoration: new BoxDecoration(
                                      color: HattoColors.colorPrimary,
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(8))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2, right: 2, top: 2, bottom: 2),
                                    child: Center(
                                      child: Text(
                                        "Super VIP".toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 7,
                                            fontFamily: 'RobotoBold',
                                            color: Colors.white),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(width: 3),
                            Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          getRankIcon(widget.items.rank_id))),
                                )),
                            SizedBox(width: 3),
                            Text(
                              widget.items.rank_desc,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Text(
                      AppUtils.formatNumber(widget.items.remain_rewards),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'RobotoMedium',
                          color: HattoColors.colorPrimary),
                    ),
                    SizedBox(width: 1),
                    Container(
                        width: 15,
                        height: 15,
                        child: Image.asset("assets/launcher/ic_dua.png"))
                  ],
                ),
              )
            ],
          ),
        ),
        body: RefreshConfiguration(
          // two attrs enable footer implements the effect in header default
          enableBallisticLoad: false,
          footerTriggerDistance: -80,
          child: SmartRefresher(
            controller: _controller,
            enablePullUp: false,
            enablePullDown: true,
            header: GifHeader1(),
            onRefresh: () async {
              await Future.delayed(Duration(milliseconds: 1000));
              _controller.refreshCompleted();
            },
            onLoading: () async {
              await Future.delayed(Duration(milliseconds: 1000));
              _controller.loadFailed();
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: WillPopScope(
                    onWillPop: () async {
                      Navigator.pop(context, widget.items);
                      return true;
                    },
                    child: GestureDetector(
                      onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      child: Container(
                        color: Colors.black,
                        width: size.width,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                List<String> url = [];
                                url.add(widget.items.URL_img_id);
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            GalleryPhotoZoom(url)));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: size.height / 2,
                                    child: Hero(
                                      tag: widget.index.toString()+widget.items.forum_id,
                                      child: CachedNetworkImage(
                                          imageUrl: widget.items.URL_img_id,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                      child: Image.asset(
                                          "assets/launcher/ic_rectangle_green.png",
                                          width: 35,
                                          height: 45),
                                      left: 10),
                                  Positioned(
                                    child: Image.asset(
                                        "assets/launcher/ic_buaan.png",
                                        width: 20,
                                        height: 20,
                                        color: Colors.white),
                                    left: 17.5,
                                    top: 10,
                                  ),
                                  Positioned(
                                    child: Container(
                                      width: size.width,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                            HattoColors.gradientBlackStart,
                                            HattoColors.gradientBlackEnd
                                          ])),
                                    ),
                                    top: size.height / 2 - 100,
                                  ),
                                  Positioned(
                                    child: Container(
                                        height: 55,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        width: size.width,
                                        child: Row(children: [
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Colors.white),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                        "assets/launcher/ic_couple.png",
                                                        width: 20,
                                                        height: 20),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "${widget.items.NUM_CHOICE_MATCHES}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "RobotoMedium",
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        "món hạp gu",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "RobotoItalic",
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: HattoColors
                                                          .colorPrimary),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                        "assets/launcher/ic_connections_2x.png",
                                                        width: 20,
                                                        height: 20),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Flexible(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "${widget.items.NUM_MATCHES + widget.items.i_found}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "RobotoMedium",
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        "món tương tự",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "RobotoItalic",
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Colors.white),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                        "assets/launcher/ic_dua.png",
                                                        width: 20,
                                                        height: 20),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Flexible(
                                                  child: Column(
                                                      children: [
                                                        Text(
                                                          "+${widget.items.forum_rewards}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "RobotoMedium",
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          "Dưa thưởng",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "RobotoItalic",
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                      ],
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start),
                                                ),
                                              ],
                                            ),
                                          )
                                        ], mainAxisSize: MainAxisSize.max)),
                                    top: size.height / 2 - 65,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: size.height / 2 - 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  color: HattoColors.whiteGrey),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.items.class_desc,
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily: 'RobotoMedium',
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "${widget.items.total_unique_views} lượt xem",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'RobotoMedium',
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                        width: double.infinity,
                                        height: 0.7,
                                        color: HattoColors.colorTimeLine),
                                    SizedBox(height: 10),
                                    Text(
                                      widget.items.extra_desc,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'RobotoRegular',
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            "assets/launcher/ic_clock.png",
                                            width: 10,
                                            height: 10),
                                        SizedBox(width: 2),
                                        Flexible(
                                          child: Text(
                                            AppUtils.getDateTimeAgo(
                                                widget.items.timestamp),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'RobotoRegular',
                                                color:
                                                    HattoColors.colorTimeLine),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        AppUtils.getSharingOptionIcon(
                                            widget.items.sharing_option, 10, 10)
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          spreadRadius: 2,
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          offset: Offset(0, 10))
                                                    ]),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/launcher/emote_clap.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Flexible(
                                                        child: Text(
                                                      "${widget.items.voted_id_1}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              "RobotoMedium",
                                                          color: Colors.black),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ))
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                voteFunction(1);
                                              },
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                voteFunction(2);
                                              },
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          spreadRadius: 2,
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          offset: Offset(0, 10))
                                                    ]),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/launcher/emote_rose.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Flexible(
                                                        child: Text(
                                                      "${widget.items.voted_id_2}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              "RobotoMedium",
                                                          color: Colors.black),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                voteFunction(3);
                                              },
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          spreadRadius: 2,
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          offset: Offset(0, 10))
                                                    ]),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/launcher/emote_suprise.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Flexible(
                                                        child: Text(
                                                      "${widget.items.voted_id_3}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              "RobotoMedium",
                                                          color: Colors.black),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 10,
                                                          spreadRadius: 2,
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          offset: Offset(0, 10))
                                                    ]),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/launcher/ic_chat_2x.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Flexible(
                                                        child: Text(
                                                      "${widget.items.replies_count}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                              "RobotoMedium",
                                                          color: Colors.black),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 70,
                                    )
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
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(
                                width: 1.0,
                                color: HattoColors.colorTimeLine
                                    .withOpacity(0.2)))),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: TextField(
                            onChanged: (text) {
                              setState(() {
                                if (text.isEmpty) {
                                  widget.boxCommentTextChange = false;
                                } else {
                                  widget.boxCommentTextChange = true;
                                }
                              });
                            },
                            controller: boxCommentController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            minLines: 1,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'RobotoRegular',
                                color: Colors.black),
                            decoration: InputDecoration(
                                hintText: "Viết bình luận...",
                                hintStyle: TextStyle(
                                    fontSize: 15, fontFamily: 'RobotoRegular'),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (boxCommentController.text.isNotEmpty) {
                              Fluttertoast.showToast(
                                  msg: boxCommentController.text,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black45,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              boxCommentController.clear();
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              setState(() {
                                widget.boxCommentTextChange = false;
                              });
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: buildImageOntextChange(
                                widget.boxCommentTextChange),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Image buildImageOntextChange(bool value) => value
      ? Image.asset(
          "assets/launcher/ic_right_arrow.png",
          color: Colors.blue,
          width: 20,
          height: 20,
        )
      : Image.asset(
          "assets/launcher/ic_right_arrow.png",
          color: HattoColors.colorTimeLine,
          width: 20,
          height: 20,
        );
}

class GifHeader1 extends RefreshIndicator {
  GifHeader1() : super(height: 80.0, refreshStyle: RefreshStyle.Follow);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GifHeader1State();
  }
}

class GifHeader1State extends RefreshIndicatorState<GifHeader1>
    with SingleTickerProviderStateMixin {
  GifController _gifController;

  @override
  void initState() {
    // TODO: implement initState
    // init frame is 2
    _gifController = GifController(
      vsync: this,
      value: 1,
    );
    super.initState();
  }

  @override
  void onModeChange(RefreshStatus mode) {
    // TODO: implement onModeChange
    if (mode == RefreshStatus.refreshing) {
      _gifController.repeat(
          min: 0, max: 29, period: Duration(milliseconds: 500));
    }
    super.onModeChange(mode);
  }

  @override
  Future<void> endRefresh() {
    // TODO: implement endRefresh
    _gifController.value = 30;
    return _gifController.animateTo(59, duration: Duration(milliseconds: 500));
  }

  @override
  void resetValue() {
    // TODO: implement resetValue
    // reset not ok , the plugin need to update lowwer
    _gifController.value = 0;
    super.resetValue();
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    final Size size = MediaQuery.of(context).size;
    // TODO: implement buildContent
    return GifImage(
      image: AssetImage("assets/launcher/indicatorloader.gif"),
      controller: _gifController,
      height: 80.0,
      width: size.width,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _gifController.dispose();
    super.dispose();
  }
}

class GifFooter1 extends StatefulWidget {
  GifFooter1() : super();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GifFooter1State();
  }
}

class _GifFooter1State extends State<GifFooter1>
    with SingleTickerProviderStateMixin {
  GifController _gifController;

  @override
  void initState() {
    // TODO: implement initState
    // init frame is 2
    _gifController = GifController(
      vsync: this,
      value: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // TODO: implement build
    return CustomFooter(
      height: 80,
      builder: (context, mode) {
        return GifImage(
          image: AssetImage("assets/launcher/indicatorloader.gif"),
          controller: _gifController,
          height: 80.0,
          width: 537,
        );
      },
      loadStyle: LoadStyle.ShowWhenLoading,
      onModeChange: (mode) {
        if (mode == LoadStatus.loading) {
          _gifController.repeat(
              min: 0, max: 29, period: Duration(milliseconds: 500));
        }
      },
      endLoading: () async {
        _gifController.value = 30;
        return _gifController.animateTo(59,
            duration: Duration(milliseconds: 500));
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _gifController.dispose();
    super.dispose();
  }
}
