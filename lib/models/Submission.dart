
import 'package:json_annotation/json_annotation.dart';

part 'Submission.g.dart';

@JsonSerializable(explicitToJson: true)
class Submission {
  String class_desc,extra_desc,URL_img_id;

  Submission(this.class_desc, this.extra_desc, this.URL_img_id);


  factory Submission.fromJson(Map <String,dynamic> data) =>_$SubmissionFromJson(data);

  Map<String,dynamic> toJson() => _$SubmissionToJson(this);


}