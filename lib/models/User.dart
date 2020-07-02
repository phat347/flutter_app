import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';


part 'User.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends ChangeNotifier{
  int SVIP_chef,SVIP_loc,SVIP_special,VIP,DUA_TO_GAO_RATE;

  String background_url;
  String birthday,email,info;

  String next_rank_desc,rank_desc;
  int rank_id,next_rank_dua,num_friends,remain_dua_rank;

  String portrait_url;

  int remain_GAO;
  int rewards;

  String role_desc,role_icon;
  String user_id,user_name;

  User(this.SVIP_chef, this.SVIP_loc, this.SVIP_special, this.VIP,
      this.DUA_TO_GAO_RATE, this.background_url, this.birthday, this.email,
      this.info, this.next_rank_desc, this.rank_desc, this.rank_id,
      this.next_rank_dua, this.num_friends, this.remain_dua_rank,
      this.portrait_url, this.remain_GAO, this.rewards, this.role_desc,
      this.role_icon, this.user_id, this.user_name);



  factory User.fromJson(Map <String,dynamic> data) =>_$UserFromJson(data);

  Map<String,dynamic> toJson() => _$UserToJson(this);


  bool isVipCheck(){
    bool isVip = false;
    if (SVIP_chef != 0 || SVIP_loc != 0 || VIP != 0 || SVIP_special!=0) {
      isVip = true;
    }
    return isVip;
  }

  updateItem(){
    notifyListeners();
  }

}