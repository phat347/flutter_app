import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'FamousGroup.g.dart';
@JsonSerializable(explicitToJson: true)
class FamousGroup extends ChangeNotifier{



  String group_name,icon_url;
  int group_position,role_group;
  bool _selected = false;
  FamousGroup(this.group_name, this.icon_url, this.group_position,
      this.role_group);

  factory FamousGroup.fromJson(Map <String,dynamic> data) =>_$FamousGroupFromJson(data);

  Map<String,dynamic> toJson() => _$FamousGroupToJson(this);

  bool get selected => _selected;

  set setSelected(bool value) {
    _selected = value;
  }

}