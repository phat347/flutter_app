import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/HattoColors.dart';
import 'package:flutterapp/models/Submission.dart';
import 'package:flutterapp/rank_master.dart';

class DetailSubmission extends StatelessWidget {
  final Submission items;
  List<dynamic> rank = rank_master;

  DetailSubmission(this.items);

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
            getAvatarUser(items),
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
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                Text(
                                  items.remain_rewards.toString(),
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
                                    child:
                                        Image.asset("assets/launcher/ic_dua.png"))
                              ],
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
          ],
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Hero(
                tag: items.forum_id,
                child: CachedNetworkImage(
                    imageUrl: items.URL_img_id, fit: BoxFit.cover),
              ),
            )
          ],
        ),
      ),
    );
  }
}
