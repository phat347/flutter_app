// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Submission _$SubmissionFromJson(Map<String, dynamic> json) {
  return Submission(
    json['class_desc'] as String,
    json['extra_desc'] as String,
    json['URL_img_id'] as String,
    json['portrait_url'] as String,
    json['user_name'] as String,
    json['rank_desc'] as String,
    json['forum_id'] as String,
    json['NUM_CHOICE_MATCHES'] as int,
    json['NUM_MATCHES'] as int,
    json['SVIP_chef'] as int,
    json['SVIP_loc'] as int,
    json['URL_cropped_bbox_id'] as String,
    json['VIP'] as int,
    json['action_type'] as int,
    json['approved'] as int,
    json['bbox_id'] as String,
    json['class_id'] as int,
    json['class_name'] as String,
    (json['gps_lat'] as num)?.toDouble(),
    (json['gps_long'] as num)?.toDouble(),
    json['id'] as int,
    json['img_id'] as String,
    json['last_edited'] as String,
    json['location_address'] as String,
    (json['location_avg_rating'] as num)?.toDouble(),
    json['location_full_desc'] as String,
    json['location_img_header_url'] as String,
    json['location_name'] as String,
    json['location_email'] as String,
    json['predict_count'] as int,
    json['rank_id'] as int,
    json['remain_rewards'] as int,
    json['timestamp'] as String,
    json['user_location_id'] as String,
    json['voted_id_1'] as int,
    json['voted_id_2'] as int,
    json['voted_id_3'] as int,
    json['voted_id_4'] as int,
    json['voted_id_5'] as int,
    json['role_desc'] as String,
    json['location_forum_id'] as String,
    json['SVIP_special'] as int,
    json['role_active'] as int,
    json['role_id'] as int,
    json['role_icon'] as String,
    json['recipe_or_cooking'] as int,
    json['location_ownership'] as int,
    json['sharing_option'] as int,
    (json['location_gps_lat'] as num)?.toDouble(),
    (json['location_gps_long'] as num)?.toDouble(),
    (json['distance'] as num)?.toDouble(),
    json['FREE_ship_chinhdanh'] as int,
    (json['min_order_FREE_ship'] as num)?.toDouble(),
    json['replies_count'] as int,
    json['favorite_count'] as int,
    json['total_unique_views'] as int,
    json['i_found'] as int,
    json['forum_rewards'] as int,
    json['location_home_delivery'] as int,
  )
    ..isVIP_normal = json['isVIP_normal'] as bool
    ..isVIP_chef = json['isVIP_chef'] as bool
    ..isVIP_loc = json['isVIP_loc'] as bool
    ..isVIP_special = json['isVIP_special'] as bool;
}

Map<String, dynamic> _$SubmissionToJson(Submission instance) =>
    <String, dynamic>{
      'class_desc': instance.class_desc,
      'extra_desc': instance.extra_desc,
      'URL_img_id': instance.URL_img_id,
      'portrait_url': instance.portrait_url,
      'user_name': instance.user_name,
      'rank_desc': instance.rank_desc,
      'forum_id': instance.forum_id,
      'NUM_CHOICE_MATCHES': instance.NUM_CHOICE_MATCHES,
      'NUM_MATCHES': instance.NUM_MATCHES,
      'SVIP_chef': instance.SVIP_chef,
      'SVIP_loc': instance.SVIP_loc,
      'URL_cropped_bbox_id': instance.URL_cropped_bbox_id,
      'VIP': instance.VIP,
      'action_type': instance.action_type,
      'approved': instance.approved,
      'bbox_id': instance.bbox_id,
      'class_id': instance.class_id,
      'class_name': instance.class_name,
      'gps_lat': instance.gps_lat,
      'gps_long': instance.gps_long,
      'id': instance.id,
      'img_id': instance.img_id,
      'last_edited': instance.last_edited,
      'location_address': instance.location_address,
      'location_avg_rating': instance.location_avg_rating,
      'location_full_desc': instance.location_full_desc,
      'location_img_header_url': instance.location_img_header_url,
      'location_name': instance.location_name,
      'location_email': instance.location_email,
      'predict_count': instance.predict_count,
      'rank_id': instance.rank_id,
      'remain_rewards': instance.remain_rewards,
      'timestamp': instance.timestamp,
      'user_location_id': instance.user_location_id,
      'voted_id_1': instance.voted_id_1,
      'voted_id_2': instance.voted_id_2,
      'voted_id_3': instance.voted_id_3,
      'voted_id_4': instance.voted_id_4,
      'voted_id_5': instance.voted_id_5,
      'role_desc': instance.role_desc,
      'location_forum_id': instance.location_forum_id,
      'SVIP_special': instance.SVIP_special,
      'role_active': instance.role_active,
      'role_id': instance.role_id,
      'role_icon': instance.role_icon,
      'recipe_or_cooking': instance.recipe_or_cooking,
      'location_ownership': instance.location_ownership,
      'sharing_option': instance.sharing_option,
      'location_gps_lat': instance.location_gps_lat,
      'location_gps_long': instance.location_gps_long,
      'distance': instance.distance,
      'FREE_ship_chinhdanh': instance.FREE_ship_chinhdanh,
      'min_order_FREE_ship': instance.min_order_FREE_ship,
      'replies_count': instance.replies_count,
      'favorite_count': instance.favorite_count,
      'total_unique_views': instance.total_unique_views,
      'i_found': instance.i_found,
      'forum_rewards': instance.forum_rewards,
      'location_home_delivery': instance.location_home_delivery,
      'isVIP_normal': instance.isVIP_normal,
      'isVIP_chef': instance.isVIP_chef,
      'isVIP_loc': instance.isVIP_loc,
      'isVIP_special': instance.isVIP_special,
    };
