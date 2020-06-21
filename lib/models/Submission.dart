
import 'package:json_annotation/json_annotation.dart';

part 'Submission.g.dart';

@JsonSerializable(explicitToJson: true)
class Submission {
  String class_desc,
      extra_desc,
      URL_img_id,
      portrait_url,
      user_name,
      rank_desc,
      forum_id;


  int NUM_CHOICE_MATCHES;

  int NUM_MATCHES;

  int SVIP_chef;

  int SVIP_loc;

  String URL_cropped_bbox_id;

  int VIP;

  int action_type;

  int approved;

  String bbox_id;

  int class_id;

  String class_name;

  double gps_lat,gps_long;

  int id;

  String img_id;

  String last_edited;

  String location_address;

  int location_avg_rating;

  String location_full_desc;

  String location_img_header_url;

  String location_name;

  String location_email;

  int predict_count;

  int rank_id;

  int remain_rewards;

  String timestamp;

  String user_location_id;

  int voted_id_1,voted_id_2,voted_id_3,voted_id_4,voted_id_5;

  String role_desc;

  String location_forum_id;

  int SVIP_special;


  int role_active;

  int role_id;

  String role_icon;

  int recipe_or_cooking;

  int location_ownership;

  int sharing_option;

  double location_gps_lat;

  double location_gps_long;

  double distance;

  int FREE_ship_chinhdanh;

  double min_order_FREE_ship;

  int replies_count;

  int favorite_count;

  int total_unique_views;

  int i_found;

  int forum_rewards;

   bool isVIP_normal = false;
   bool isVIP_chef = false;
   bool isVIP_loc = false;
   bool isVIP_special = false;

  Submission(this.class_desc, this.extra_desc, this.URL_img_id,
      this.portrait_url, this.user_name, this.rank_desc, this.forum_id,
      this.NUM_CHOICE_MATCHES, this.NUM_MATCHES, this.SVIP_chef, this.SVIP_loc,
      this.URL_cropped_bbox_id, this.VIP, this.action_type, this.approved,
      this.bbox_id, this.class_id, this.class_name,
      this.gps_lat, this.gps_long, this.id, this.img_id, this.last_edited,
      this.location_address, this.location_avg_rating, this.location_full_desc,
      this.location_img_header_url, this.location_name, this.location_email,
      this.predict_count, this.rank_id,
      this.remain_rewards, this.timestamp, this.user_location_id,
      this.voted_id_1, this.voted_id_2, this.voted_id_3, this.voted_id_4,
      this.voted_id_5, this.role_desc, this.location_forum_id,
      this.SVIP_special, this.role_active, this.role_id, this.role_icon,
      this.recipe_or_cooking, this.location_ownership, this.sharing_option,
      this.location_gps_lat, this.location_gps_long, this.distance,
      this.FREE_ship_chinhdanh, this.min_order_FREE_ship,this.replies_count,this.favorite_count,this.total_unique_views,this.i_found,this.forum_rewards);



  factory Submission.fromJson(Map <String,dynamic> data) =>_$SubmissionFromJson(data);

  Map<String,dynamic> toJson() => _$SubmissionToJson(this);

  bool isVipCheck(){
    bool isVip = false;
    if (SVIP_chef != 0 || SVIP_loc != 0 || VIP != 0 || SVIP_special!=0) {
      isVip = true;
    }
    return isVip;
  }
}