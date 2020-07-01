// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecipeSearch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeSearch _$RecipeSearchFromJson(Map<String, dynamic> json) {
  return RecipeSearch(
    json['display'] as String,
    json['icon_url'] as String,
    json['key'] as int,
    json['position'] as int,
    json['quick_search_enabled'] as bool,
    json['submit_group'] as String,
    json['famous'] as int,
    json['FREE_ship_chinhdanh'] as int,
    json['video_yes'] as int,
  );
}

Map<String, dynamic> _$RecipeSearchToJson(RecipeSearch instance) =>
    <String, dynamic>{
      'display': instance.display,
      'icon_url': instance.icon_url,
      'key': instance.key,
      'position': instance.position,
      'quick_search_enabled': instance.quick_search_enabled,
      'submit_group': instance.submit_group,
      'famous': instance.famous,
      'FREE_ship_chinhdanh': instance.FREE_ship_chinhdanh,
      'video_yes': instance.video_yes,
    };
