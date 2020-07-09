import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterapp/HattoColors.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class LiquidSwipeScreen extends StatefulWidget {
  @override
  _LiquidSwipeScreenState createState() => _LiquidSwipeScreenState();
}

class _LiquidSwipeScreenState extends State<LiquidSwipeScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<LiquidSwipeScreen> {
  @override
  Widget build(BuildContext context) {
    final pages = [
      Container(
        color: HattoColors.colorPrimary,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: SvgPicture.asset(
                "assets/images/food.svg",
                color: Colors.white,
              ),
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              "Nơi ai cũng có thể sành ăn ",
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: 'RobotoBold'),
            )),
          ],
        ),
      ),
      Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: SvgPicture.asset(
                "assets/images/food.svg",
                color: HattoColors.colorPrimary,
              ),
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              "Nơi ai cũng có thể sành ăn",
              style: TextStyle(
                  color: HattoColors.colorPrimary,
                  fontSize: 15,
                  fontFamily: 'RobotoBold'),
            )),
          ],
        ),
      ),
    ];

    return Scaffold(
      body: LiquidSwipe(enableLoop: true, enableSlideIcon: false, pages: pages),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
