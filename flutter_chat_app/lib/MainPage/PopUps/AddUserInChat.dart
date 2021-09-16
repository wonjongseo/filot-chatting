import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/MainPage/Chatting/ChattingRoom.dart';
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
  late StateSetter setState;

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

  Widget _addUser(int index){
    var userObj = _friends[index];
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide( // POINT
            color: Colors.black12,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: _rateHeight * 5,
            height: _rateHeight * 5,
            child:Icon(Icons.album_outlined,size: 25,color: _friendsFlag[index] ? Colors.yellow : Colors.grey,),
          ),
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
              userObj.getName(), style: TextStyle(color: Colors.black87, fontSize: 15,fontWeight: FontWeight.bold),),
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
      builder: (context){
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          this.setState = setState;
          return AlertDialog(
                title: Text('초대하기', style: TextStyle(
                    fontFamily: 'bmjua'
                ),),
                content: Container(
                  child: Column(
                    children: [
                      /// List scrollable and setstate
                      Flexible(
                        child: ListView(
                          controller: new ScrollController(),
                          children: [
                            for(var index = 0; index < _friends.length; index++)
                              ListTile(
                                title: _addUser(index),
                                onTap: () {
                                  print("hi");
                                  setState((){
                                    _friendsFlag[index] = !_friendsFlag[index];
                                  });
                                },
                            ),
                          ],
                          semanticChildCount: _friends.length,
                        ),
                      ),
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
                        fontFamily: 'bmjua',
                      color: Colors.blue
                    ),),
                    onPressed: () {
                      /// Invite 친구들 탐색하고 보내주기
                      for(int i = 0;i < _friendsFlag.length;i++)
                        if(_friendsFlag[i])
                          _invite_friends.add(_friends[i]);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chatting(friendsObjs: _invite_friends)));
                    },
                  ),
                  TextButton(
                    child: Text('취소', style: TextStyle(
                        fontFamily: 'bmjua',
                      color: Colors.black26
                    ),),
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
    setState((){});
  }
  bool _isExist(UserData userData){
    for(var item in _invite_friends)
      if(item.getName() == userData.getName())
        return true;
    return false;
  }
}