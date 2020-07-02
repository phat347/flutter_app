import 'package:flutter/material.dart';
import 'package:flutterapp/HattoColors.dart';

class CustomDialogs extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;

  CustomDialogs({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: WillPopScope(onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },child: buildContainer(context))
    );
  }

  Stack buildContainer(BuildContext context) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: 50),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // To close the dialog
                  },
                  child: Text(buttonText.toUpperCase(),style: TextStyle(
                      fontFamily: 'RobotoBold',
                      color: Colors.black
                  )),
                ),
              ),
            ],
          ),
        ),
        //...top circlular image part,
        Positioned(
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Container(
              width: 100,height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60))
                ,color: HattoColors.colorPrimary),
              child: Image.asset("assets/images/combinedshape.png",scale: 0.7,width: 100,height: 100,color: Colors.white,),
            ),
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
