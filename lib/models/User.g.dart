// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['SVIP_chef'] as int,
    json['SVIP_loc'] as int,
    json['SVIP_special'] as int,
    json['VIP'] as int,
    json['DUA_TO_GAO_RATE'] as int,
    json['background_url'] as String,
    json['birthday'] as String,
    json['email'] as String,
    json['info'] as String,
    json['next_rank_desc'] as String,
    json['rank_desc'] as String,
    json['rank_id'] as int,
    json['next_rank_dua'] as int,
    json['num_friends'] as int,
    json['remain_dua_rank'] as int,
    json['portrait_url'] as String,
    json['remain_GAO'] as int,
    json['rewards'] as int,
    json['role_desc'] as String,
    json['role_icon'] as String,
    json['user_id'] as String,
    json['user_name'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'SVIP_chef': instance.SVIP_chef,
      'SVIP_loc': instance.SVIP_loc,
      'SVIP_special': instance.SVIP_special,
      'VIP': instance.VIP,
      'DUA_TO_GAO_RATE': instance.DUA_TO_GAO_RATE,
      'background_url': instance.background_url,
      'birthday': instance.birthday,
      'email': instance.email,
      'info': instance.info,
      'next_rank_desc': instance.next_rank_desc,
      'rank_desc': instance.rank_desc,
      'rank_id': instance.rank_id,
      'next_rank_dua': instance.next_rank_dua,
      'num_friends': instance.num_friends,
      'remain_dua_rank': instance.remain_dua_rank,
      'portrait_url': instance.portrait_url,
      'remain_GAO': instance.remain_GAO,
      'rewards': instance.rewards,
      'role_desc': instance.role_desc,
      'role_icon': instance.role_icon,
      'user_id': instance.user_id,
      'user_name': instance.user_name,
    };
