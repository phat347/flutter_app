
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'RecipeSearch.g.dart';

@JsonSerializable(explicitToJson: true)
class RecipeSearch extends ChangeNotifier{

  String display;
  String icon_url;
  int key;
  int position;
  bool quick_search_enabled;
  String submit_group;
  int famous;
  int FREE_ship_chinhdanh;
  int video_yes;

  bool _selected = false;
  RecipeSearch(this.display, this.icon_url, this.key, this.position,
      this.quick_search_enabled, this.submit_group, this.famous,
      this.FREE_ship_chinhdanh, this.video_yes);



  factory RecipeSearch.fromJson(Map <String,dynamic> data) =>_$RecipeSearchFromJson(data);

  Map<String,dynamic> toJson() => _$RecipeSearchToJson(this);

  bool get selected => _selected;

  set setSelected(bool value) {
    _selected = value;
  }


}