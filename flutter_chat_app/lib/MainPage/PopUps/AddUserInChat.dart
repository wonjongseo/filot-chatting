import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/data/FrinedsData.dart';
import 'package:flutter_chat_app/data/ProfileData.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:http/http.dart' as http;

class AddUserInChat {
  final _getUsersData_api = ServerData.api + (ServerData.ApiList['/friends'] as String);
  BuildContext context;
  List<FrinedsData> _friends = [];
  List<bool> _friendsFlag = [];
  late List<FrinedsData> _invite_friends;

  var deviceHeight,deviceWidth;
  var _rateHeight,_rateWidth;

  AddUserInChat( {required this.context, List<FrinedsData>? invite_friends}){
    _invite_friends = invite_friends == null ? [] : invite_friends;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    _rateHeight = deviceHeight/ 100;
    _rateWidth = deviceWidth / 100;
    _getData();
  }

  Widget _addUser(UserData item){
    var userObj = item;
    var _rateHeight = this._rateHeight + 3;
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: _rateHeight * 5,
            height: _rateHeight * 5,
            child: Image.asset(userObj.getImage(), fit: BoxFit.fill,),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(
                  const Radius.circular(100)),
            ),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0),),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(const Radius.circular(5)),
            ),
            child: Text(
              item.getName(), style: TextStyle(color: Colors.black87, fontSize: 15,fontWeight: FontWeight.bold),),
            padding: EdgeInsets.all(8),
          )
        ],
      ),
      padding: EdgeInsets.fromLTRB(3, 4, 2, 3),
    );
  }
  void popUp(){
    bool flag = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
                title: Text("초대하기"),
                content: Container(
                  child: Column(
                    children: [
                      /// List scrollable and setstate
                      Text(flag ? "true" : "false")
                    ],
                  ),
                  height: _rateHeight * 50,
                  width: _rateWidth * 80,
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('초대하기', style: TextStyle(
                        fontFamily: 'bmjua'
                    ),),
                    onPressed: () {
                      setState((){
                        flag = !flag;
                      });
                    },
                  ),
                  TextButton(
                    child: Text('취소'),
                    onPressed: () {
                      Navigator.pop(context, "Cancel");
                    },
                  ),
                ],
                backgroundColor: Colors.white,
              );
        },);
      }
    );
  }

  /// 실제 친구 데이터들을 불러오는 메소드
  void _getData() async{
    // 모든 정보를 업데이트 한다.
    var _tokenValue;
    try {
      _tokenValue = myData.getToken();
    }catch (e){
      print(e.toString());
    }

    final response = await http.get(
        Uri.parse(_getUsersData_api),
        headers: {'Content-Type': "application/json",
          ServerData.KeyList['token'] as String : _tokenValue,
        }
    );
    if(response.statusCode < 200 || response.statusCode >= 300){
      return;
    }

    var data;
    try {
      data = jsonDecode(response.body);
    }catch(e){
      print(e.toString());
    }
    try {
      print(data);
      for (var item in data) {
        FrinedsData _item = new FrinedsData(item);

        if(_item.parsingData()) {
          _friends.add(_item);
          _friendsFlag.add(_isExist(_item));
        }
        else
          print("error for adding friend");
      }
    } catch (e) {
      print(e.toString());
    }
    _invite_friends.clear();
  }
  bool _isExist(UserData userData){
    for(var item in _invite_friends)
      if(item.getName() == userData.getName())
        return true;
    return false;
  }
}
/*
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/MainPage/Chatting/ChatList.dart';
import 'package:flutter_chat_app/data/FrinedsData.dart';
import 'package:flutter_chat_app/data/ProfileData.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:http/http.dart' as http;

class AddUserInChat extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return createState() => _AddUserInChat();
  }

}

class _AddUserInChat extends State<AddUserInChat>{
  final _getUsersData_api = ServerData.api + (ServerData.ApiList['/friends'] as String);
  BuildContext context;
  List<FrinedsData> _friends = [];
  List<bool> _friendsFlag = [];
  late List<FrinedsData> _invite_friends;

  var deviceHeight,deviceWidth;
  var _rateHeight,_rateWidth;

  AddUserInChat( {required this.context, List<FrinedsData>? invite_friends}){
    _invite_friends = invite_friends == null ? [] : invite_friends;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    _rateHeight = deviceHeight/ 100;
    _rateWidth = deviceWidth / 100;
    _getData();
  }

  Widget _addUser(UserData item){
    var userObj = item;
    var _rateHeight = this._rateHeight + 3;
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: _rateHeight * 5,
            height: _rateHeight * 5,
            child: Image.asset(userObj.getImage(), fit: BoxFit.fill,),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(
                  const Radius.circular(100)),
            ),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0),),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(const Radius.circular(5)),
            ),
            child: Text(
              item.getName(), style: TextStyle(color: Colors.black87, fontSize: 15,fontWeight: FontWeight.bold),),
            padding: EdgeInsets.all(8),
          )
        ],
      ),
      padding: EdgeInsets.fromLTRB(3, 4, 2, 3),
    );
  }
  void popUp(){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("초대하기"),
          content: Container(
            child: Column(
              children: [

              ],
            ),
            height: _rateHeight * 50,
            width: _rateWidth * 80,
            decoration: BoxDecoration(
              color: Colors.white
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('초대하기', style: TextStyle(
                fontFamily: 'bmjua'
              ),),
              onPressed: () {
                Navigator.pop(context, "OK");
              },
            ),
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }

  /// 실제 친구 데이터들을 불러오는 메소드
  void _getData() async{
    // 모든 정보를 업데이트 한다.
    var _tokenValue;
    try {
      _tokenValue = myData.getToken();
    }catch (e){
      print(e.toString());
    }

    final response = await http.get(
        Uri.parse(_getUsersData_api),
        headers: {'Content-Type': "application/json",
          ServerData.KeyList['token'] as String : _tokenValue,
        }
    );
    if(response.statusCode < 200 || response.statusCode >= 300){
      return;
    }

    var data;
    try {
      data = jsonDecode(response.body);
    }catch(e){
      print(e.toString());
    }
    try {
      print(data);
      for (var item in data) {
        FrinedsData _item = new FrinedsData(item);

        if(_item.parsingData()) {
          _friends.add(_item);
          _friendsFlag.add(_isExist(_item));
        }
        else
          print("error for adding friend");
      }
    } catch (e) {
      print(e.toString());
    }
    _invite_friends.clear();
  }
  bool _isExist(UserData userData){
    for(var item in _invite_friends)
      if(item.getName() == userData.getName())
        return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
 */