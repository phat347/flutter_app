import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/HattoColors.dart';
import 'package:flutterapp/Utils/AppUtils.dart';
import 'package:flutterapp/models/Submission.dart';
import 'package:flutterapp/rank_master.dart';
import 'package:flutterapp/screens/GalleryPhotoZoom.dart';

class DetailSubmission extends StatelessWidget {
  final Submission items;
  int index;
  List<dynamic> rank = rank_master;

  DetailSubmission(this.items, this.index);

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
                tag: index.toString() + items.portrait_url,
                child: getAvatarUser(items)),
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
                                items.user_name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'RobotoMedium',
                                    color: items.isVipCheck()
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
                            visible: items.isVipCheck() ? false : true,
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
                                        getRankIcon(items.rank_id))),
                              )),
                          SizedBox(width: 3),
                          Text(
                            items.rank_desc,
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
                    AppUtils.formatNumber(items.remain_rewards),
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Colors.black,
          width: size.width,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  List<String> url = [];
                  url.add(items.URL_img_id);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => GalleryPhotoZoom(url)));
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: size.height / 2,
                      child: Hero(
                        tag: items.forum_id,
                        child: CachedNetworkImage(
                            imageUrl: items.URL_img_id, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                        child: Image.asset(
                            "assets/launcher/ic_rectangle_green.png",
                            width: 35,
                            height: 45),
                        left: 10),
                    Positioned(
                      child: Image.asset("assets/launcher/ic_buaan.png",
                          width: 20, height: 20, color: Colors.white),
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
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height / 2 - 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: HattoColors.whiteGrey),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items.class_desc,
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'RobotoMedium',
                            color: Colors.black),
                      ),
                      Text(
                        "${items.total_unique_views} lượt xem",
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
                        items.extra_desc,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'RobotoRegular',
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/launcher/ic_clock.png",
                              width: 10, height: 10),
                          SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              AppUtils.getDateTimeAgo(items.timestamp),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'RobotoRegular',
                                  color: HattoColors.colorTimeLine),
                            ),
                          ),
                          SizedBox(width: 5),
                          AppUtils.getSharingOptionIcon(
                              items.sharing_option, 10, 10)
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/launcher/emote_clap.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(height: 2,),
                                    Flexible(
                                        child: Text(
                                      "${items.voted_id_1}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "RobotoMedium",
                                          color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ))
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/launcher/emote_rose.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(height: 2,),
                                    Flexible(
                                        child: Text(
                                          "${items.voted_id_2}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "RobotoMedium",
                                              color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/launcher/emote_suprise.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(height: 2,),
                                    Flexible(
                                        child: Text(
                                          "${items.voted_id_3}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "RobotoMedium",
                                              color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/launcher/ic_chat_2x.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(height: 2,),
                                    Flexible(
                                        child: Text(
                                          "${items.replies_count}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "RobotoMedium",
                                              color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20,)
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
