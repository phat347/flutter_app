
import 'package:json_annotation/json_annotation.dart';

part 'Submission.g.dart';

@JsonSerializable(explicitToJson: true)
class Submission {
  String class_desc,extra_desc,URL_img_id,portrait_url,user_name,rank_desc;


  Submission(this.class_desc, this.extra_desc, this.URL_img_id,
      this.portrait_url, this.user_name, this.rank_desc);

  factory Submission.fromJson(Map <String,dynamic> data) =>_$SubmissionFromJson(data);

  Map<String,dynamic> toJson() => _$SubmissionToJson(this);


}