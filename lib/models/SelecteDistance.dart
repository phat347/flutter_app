import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';


part 'SelecteDistance.g.dart';
@JsonSerializable(explicitToJson: true)
class SelectDistance extends ChangeNotifier{
  String name;
  int value;




  SelectDistance(this.name, this.value);

  factory SelectDistance.fromJson(Map <String,dynamic> data) =>_$SelectDistanceFromJson(data);

  Map<String,dynamic> toJson() => _$SelectDistanceToJson(this);

}