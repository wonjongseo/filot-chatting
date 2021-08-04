import 'package:flutter_chat_app/data/ProfileData.dart';

class FrinedsData extends UserData{
  var _userObj;

  get userObj => _userObj;

  FrinedsData(name,[userObj]) : super(name){
    if(userObj != null)
      this._userObj = userObj;
  }
}
