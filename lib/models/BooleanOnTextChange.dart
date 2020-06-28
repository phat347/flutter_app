import 'package:flutter/foundation.dart';

class BooleanOnTextChange extends ChangeNotifier{
  bool textChange=false;


  updateValue(bool value){
    this.textChange = value;
    notifyListeners();
  }
}