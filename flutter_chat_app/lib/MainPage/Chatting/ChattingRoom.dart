import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/MainPage/Friends/FriendsList.dart';
import 'package:flutter_chat_app/data/FrinedsData.dart';
import 'package:flutter_chat_app/data/MyData.dart';
import 'package:flutter_chat_app/data/ProfileData.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chatting extends StatefulWidget {
  List<FrinedsData> friendsObjs;
  Chatting({Key? key, required this.friendsObjs}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Chatting(friendsObjs);
}

class _Chatting extends State<Chatting> {
  /*------------------ 변수 선언 구문 ------------------*/
  /// 소켓 접속을 위한 api
  final _socket_api = ServerData.api +
      (ServerData.ApiList['/chat']
          as String); //ServerData.api + '/see'; //10.0.2.2

  /// socket 변수 생성
  late IO.Socket socket;

  /// 친구 데이터와 내 데이터를 초기화
  List<FrinedsData> _frinedsList;
  late FrinedsData friendObj;
  MyData _myData = myData;
  _Chatting(this._frinedsList);

  /// 메시지에 대한 리스트, 이 순서대로 레이아웃이 펼쳐진다.
  List _messageList = [];

  /// 텍스트 controller와 화면을 scroll 할 수 있는 controller
  TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  String _sendText = '';

  /// 기기 사이즈를 받고, 비율을 지정
  var _rateHeight, _rateWidth;
  /*--------------------------------------------------*/

  /*------------------ 위젯 생성 메서드 구문 ------------------*/
  /// _messageList에서 요소를 받아 실제 UI를 그리는 위젯 추가 메서드
  Widget _addMessageWidget(item) {
    var _item = jsonDecode(item);

    String msg = _item[ServerData.KeyList['msg']];
    bool _isMe = (_item[ServerData.KeyList['user']] == _myData.userObj);

    if (_isMe)
      return Container(
        width: double.infinity,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(5)),
                color: Colors.grey,
              ),
              child: Text(
                msg,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              padding: EdgeInsets.all(8),
            )
          ],
        ),
        padding: EdgeInsets.fromLTRB(3, 4, 2, 3),
      );
    else {
      var userObj = friendObj;

      return Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: _rateHeight * 5,
              height: _rateHeight * 5,
              child: Image.asset(
                userObj.getImage(),
                fit: BoxFit.fill,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black12,
                  width: 1,
                ),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(100)),
              ),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(5)),
                color: Colors.blueAccent,
              ),
              child: Text(
                msg,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              padding: EdgeInsets.all(8),
            )
          ],
        ),
        padding: EdgeInsets.fromLTRB(3, 4, 2, 3),
      );
    }
  }

  /// 하단 텍스트 입력 란을 만드는 메서드
  Widget _SendTextForm([str]) => Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.black54,
              ),
              top: BorderSide(
                width: 2,
                color: Colors.black38,
              ))),
      width: _rateWidth * 100,
      height: 45,
      child: Center(
        child: Wrap(
          children: [
            Container(
              width: _rateWidth * 80,
              height: 40,
              child: TextFormField(
                controller: _textController,
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 3),
                  labelStyle: TextStyle(
                    fontSize: 15,
                  ),
                ),
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value) async {
                  _textController.clear();
                },
              ),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            ),
            IconButton(
              onPressed: () {
                _sendText = _textController.text.toString();
                if (_sendText.isEmpty) return;
                var item;
                item = jsonEncode({
                  ServerData.KeyList['msg']: _sendText,
                  ServerData.KeyList['user']: _myData.userObj
                });
                socket.emit(ServerData.KeyList['msg'] as String, item);
                setState(() {
                  _textController.clear();
                  _sendText = '';
                });
              },
              icon: Icon(Icons.arrow_upward_rounded),
              disabledColor: Colors.grey,
              color: Colors.blueAccent,
            )
          ],
        ),
      ));

  @override

  /// 실제 화면을 build하는 메소드
  Widget build(BuildContext context) {
    _rateHeight = MediaQuery.of(context).size.height / 100;
    _rateWidth = MediaQuery.of(context).size.width / 100;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(friendObj.getName()),
        primary: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/main', (route) => false);
              },
              icon: Icon(
                Icons.home,
                size: 30,
              ))
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Flexible(
            child: ListView(
              controller: _scrollController,
              children: [
                for (var item in _messageList) _addMessageWidget(item),
              ],
              semanticChildCount: _messageList.length,
            ),
          ),
          _SendTextForm(),
        ],
      ),
    );
  }
  /*--------------------------------------------------*/

  /*------------------ 데이터 처리 메서드 구문 ------------------*/
  // 아래 모든 데이터 메소드는 서버 관련 메소드 --server
  @override

  /// 이 컨텍스트가 실행되면서 초기화 메소드, Socket을 Link한다.
  void initState() {
    friendObj = _frinedsList.first;

    // TODO: implement initState
    _LinkSocket();
    super.initState();
  }

  /// 실제 Socket을 연결하는 메소드
  _LinkSocket() async {
    // 'username'
    var item;
    List<String> _tempList = [_myData.getName()];
    _frinedsList.forEach((element) {
      _tempList.add(element.getName());
    });

    _tempList.sort();
    String roomNum = '';
    for (var i in _tempList) roomNum = roomNum + i;

    item = jsonEncode({
      'user1': "jongseo", //name전송string
      'user2': "ABC",
      'roomNum': 1234,
    });

    socket = await IO.io(_socket_api, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((str) {
      print(str);
      _messageList.clear();
      socket.emit(
          ServerData.KeyList['enter-room'] as String, item); // chatting room
    });
    socket.on(ServerData.KeyList['load-message'] as String, (data) {
      print(data);
      var _preMessageList = jsonDecode(data);
      print(_preMessageList);
      for (var item in _preMessageList[ServerData.KeyList['chat']])
        _messageList.add(item);
      setState(() {});
    }); // 처음 진입 시
    socket.onDisconnect((_) => print('disconnect'));
    socket.on(ServerData.KeyList['msg'] as String, (msg) {
      print('server send msg: ${msg}');
      setState(() {
        _messageList.add(msg);
      });
    });
    socket.onDisconnect((data) {
      print('disconnect');
      _messageList.clear();
    });
  }
/*--------------------------------------------------*/
}
