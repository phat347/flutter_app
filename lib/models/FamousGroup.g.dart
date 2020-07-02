// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FamousGroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamousGroup _$FamousGroupFromJson(Map<String, dynamic> json) {
  return FamousGroup(
    json['group_name'] as String,
    json['icon_url'] as String,
    json['group_position'] as int,
    json['role_group'] as int,
  );
}

Map<String, dynamic> _$FamousGroupToJson(FamousGroup instance) =>
    <String, dynamic>{
      'group_name': instance.group_name,
      'icon_url': instance.icon_url,
      'group_position': instance.group_position,
      'role_group': instance.role_group,
    };
