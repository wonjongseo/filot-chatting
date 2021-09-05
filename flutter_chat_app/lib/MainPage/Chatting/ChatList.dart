import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/MainPage/Chatting/ChattingRoom.dart';
import 'package:flutter_chat_app/data/FrinedsData.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_app/data/ServerData.dart';

String icon_path = 'image/teamIcon.png';
String github_outline_path = 'image/github_outline.png';
String github_path = 'image/github_outline.png';


class ChatList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatList();
}

class _ChatList extends State<ChatList> {

  /*------------------ 변수 선언 구문 ------------------*/
  /// Chat List를 불러오는 api
  final _getRoomsData_api = ServerData.api + (ServerData.ApiList['/rooms'] as String);
  /// 화면을 scroll 할 수 있는 controller
  ScrollController _scrollController = new ScrollController();
  /// 채팅방 List
  List<_roomData> _Rooms = [];
  /// 기기 사이즈를 받고, 비율을 지정
  var deviceHeight, deviceWidth;
  /*--------------------------------------------------*/

  /*------------------ 위젯 생성 메서드 구문 ------------------*/
  /// 채팅방 하나의 cardview를 표현하는 위젯 메소드
  Widget _ChatCardeView(width, height, _roomData object){
    var _widthRate = width * 0.01;
    var _hegihtRate = height * 0.01;
    // 추후 User Data를 받아오는 파라미터 필요
    // 현재 위젯의 너비와 높이를 받아와서 비율을 계산

    String _title = '', _lastChat;
    object.users.forEach((element) {_title = _title + element.getName();});
    _lastChat = object.lastChat;

    return Container(
      width: _widthRate*85,
      height: _hegihtRate*80,
      child: Row(
        children: [
          // profile image
          Container(
              width: _widthRate*25,
              height: _widthRate*25,
              child: Image.asset( object.users.length > 1 ? icon_path : object.users.first.getImage(), fit: BoxFit.fill,),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black12,
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(const Radius.circular(100)),
              )
          ),
          Padding(padding: EdgeInsets.all(5),),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _widthRate*50,
                  height: _hegihtRate*33,
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Text(_title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      Padding(padding: EdgeInsets.all(_widthRate*4)),

                      Container(
                        width: _widthRate*6,
                        height: _hegihtRate*10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.green,
                            border: Border.all(
                              color: Colors.black12,
                              width: 1,
                            )
                        ),
                      ),
                    ],
                  ),

                ),
                Container(
                  height: 1,
                  width: _widthRate*55,
                  child: Divider(color: Colors.black38,),
                ),
                Padding(padding: EdgeInsets.all(3),),
                Container(
                  width: _widthRate*50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(child: Text(_lastChat, overflow: TextOverflow.ellipsis,maxLines: 1,)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override /// 실제 화면을 build하는 메소드
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    final rateWidth = (deviceWidth - 80)/100;
    final rateHeight = (deviceHeight)/100;
    var MyProfileWidget_width, MyProfileWidget_height;
    var FriendProfileWidget_width, FriendProfileWidget_height;
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget> [
          Container(
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: rateHeight*5,
                    alignment: Alignment.bottomLeft,
                    child: Icon(Icons.star,size: 40,color: Colors.yellow,),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    width: (MyProfileWidget_width=rateWidth * 100),
                    height: (MyProfileWidget_height=100.0),
                    child: Center(
                        child: GestureDetector(
                          onTap: (){
                            //_goToChatting();
                            print("아직 미구현");
                          },
                          child: _ChatCardeView(MyProfileWidget_width,MyProfileWidget_height, _roomData()),
                        )
                    ),
                  ),
                ],
              ),
            ),
            height: rateHeight*20,
          ),
          Container(height: 20,width: double.infinity, child: Center(child: Container( height: 1, width: rateWidth*100, color: Colors.black87),)),
          Flexible(
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                controller: _scrollController,
                children: [
                  for(var item in _Rooms)
                    Container(
                      height: (FriendProfileWidget_height = rateHeight * 15),
                      width: (FriendProfileWidget_width = rateWidth * 100),
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Colors.black12,
                                width: 1
                            ),
                          )
                      ),
                      child: GestureDetector(
                        onTap: () {_goToChatting(item);},
                        child: Center(child: _ChatCardeView(
                            FriendProfileWidget_width,
                            FriendProfileWidget_height,
                            item
                        )),
                      ),
                    ),
                ]
              //Column(children: [],),
            ),
          )
        ],
      ),
    );
  }
  /*--------------------------------------------------*/

  /*------------------ 데이터 처리 메서드 구문 ------------------*/
  @override /// 이 컨텍스트가 실행되면서 초기화 메소드, 친구 List들을 불러온다.
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRoom();
  }

  /// 실제 room 데이터들을 불러오는 메소드
  void _getRoom() async{

    // 모든 정보를 업데이트 한다.
    var _tokenValue;
    try {
      _tokenValue = myData.getToken();
    }catch (e){
      print(e.toString());
    }

    final response = await http.get(
        Uri.parse(_getRoomsData_api),
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
      for (var item in data)
        _Rooms.add(new _roomData(item));
      setState(() {

      });

    } catch (e) {
      print(e.toString());
    }
  }
  /// 채팅방 클릭 시 실제 해당 chatting room context로 이동시키는 메소드
  void _goToChatting(_roomData object){
    // 친구 조회 필요, 친구 객체 전달
    // 조회 및 채팅방 이동은 동기식으로 진행해야 함
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chatting(friendsObjs: object.users)));
  }
  /*--------------------------------------------------*/
}

class _roomData{
  List<FrinedsData> users = [];
  String roomNumber = '';
  String lastChat = '';

  _roomData([jsonObj]){
    if(jsonObj == null){
      var user1 = new FrinedsData(ServerData.adminItem);
      var user2 = new FrinedsData(ServerData.adminItem);
      user1.parsingData();
      user2.parsingData();
      user1.setName("test1");
      user2.setName('test2');
      users.add(user1);
      users.add(user2);
      roomNumber = '1234';
      lastChat = 'Latest Chat Text';
    }
    else {
      var data = jsonDecode(jsonObj);
      roomNumber = data[ServerData.KeyList['room']];
      var users = data[ServerData.KeyList['user']] as List;
      var chats = data[ServerData.KeyList['chat']] as List;
      lastChat = chats.last[ServerData.KeyList['msg']] as String;
      for(var item in users){
        FrinedsData temp = new FrinedsData(item);
        if(temp.parsingData()) {
          if(temp.getName() == myData.getName())
            continue;
          users.add(temp);
        }
        else
          print("error");
      }
    }
  }

}