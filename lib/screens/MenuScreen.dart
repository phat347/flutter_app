import 'package:flutter/material.dart';

import '../HattoColors.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'dart:async';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Asset> images = List<Asset>();
  String _error;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadAssets() async {

    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Action bar",
          allViewTitle: "Chọn hình",
          actionBarColor: "#ffffff",
          actionBarTitleColor: "#000000",
          lightStatusBar: true,
          textOnNothingSelected: "Bạn chưa chọn hình nào",
          statusBarColor: '#ffffff',
          useDetailsView:false,
          startInAllView: true,
          okButtonDrawable: "ic_checkbox_active",
          backButtonDrawable: "left_arrow",
          selectCircleStrokeColor: "#ffffff",
          selectionLimitReachedText: "Bạn chỉ được chọn tối đa 300 hình",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: buildGridView()),
//              Text('Error: $_error'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadAssets,
        child: Icon(
          Icons.image,
          color: Colors.white,
        ),
        backgroundColor: HattoColors.colorPrimary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
