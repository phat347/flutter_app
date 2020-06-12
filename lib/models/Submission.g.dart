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
  );
}

Map<String, dynamic> _$SubmissionToJson(Submission instance) =>
    <String, dynamic>{
      'class_desc': instance.class_desc,
      'extra_desc': instance.extra_desc,
      'URL_img_id': instance.URL_img_id,
      'portrait_url': instance.portrait_url,
      'user_name': instance.user_name,
      'rank_desc': instance.rank_desc,
    };
