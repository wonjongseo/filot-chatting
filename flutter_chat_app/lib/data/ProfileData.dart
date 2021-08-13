import 'dart:convert';

import 'package:flutter_chat_app/data/ServerData.dart';

class UserData {
  String _name = '';
  String _phone = '';
  String _email = '';
  String _github = '';
  String _role = '';
  String _imgPath = 'image/teamIcon.png';

  var _state;
  var _userObj;

  /// Server에서 json type으로 user 객체를 통째로 받아 저장한다. --server
  UserData(userObj){
    this._userObj = userObj; //json encoding된 상태
  }

  set userObj(value) {
    _userObj = value;
  }
  get userObj => _userObj;
  String getName() => _name;
  void setName(String name) => this._name = name;
  String getPhone() => _phone;
  void setPhone(String? phone) => this._phone = phone!;
  String getEmail() => _email;
  void setEmail(String? email) => this._email = email!;
  String getGithub()=> _github;
  void setGithub(String? github) => this._github = github!;
  String getRole() => _role;
  void setRole(String? role) => this._role = role!;
  dynamic getState() => _state;
  void setState(state) => this._state = state!;
  String getImage() => _imgPath;
  void setImage(String? imgPath) => this._imgPath = (imgPath!.isEmpty ? 'image/teamIcon.png' : imgPath)!;

  /// server에서 받은 user Object를 parsing하는 메소드 --server method
  bool parsingData(){
    if(_userObj.toString().isEmpty)
      return false;
    else{
      /// object parsing
      try {
        var data = jsonDecode(_userObj);
        this.setName(data[ServerData.KeyList['name']]);
        this.setRole(data[ServerData.KeyList['role']]);
        this.setPhone(data[ServerData.KeyList['phone']]);
        this.setEmail(data[ServerData.KeyList['email']]);
        this.setGithub(data[ServerData.KeyList['github']]);
        this.setState(data[ServerData.KeyList['state']]);
      } catch (e) {

      }

      return true;
    }
  }
}