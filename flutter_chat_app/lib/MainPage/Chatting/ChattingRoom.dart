import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/MyData.dart';
import 'package:flutter_chat_app/data/ProfileData.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chatting extends StatefulWidget{

  UserData  userObj;
  Chatting({Key? key,required this.userObj}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Chatting(userObj);
}
class _Chatting extends State<Chatting>{
  final _socket_api = 'http://localhost:3002' + (ServerData.ApiList['/chat'] as String); //ServerData.api + '/see'; //10.0.2.2
  late IO.Socket socket;

  UserData friendObj;
  MyData _myData = myData;
  _Chatting(this.friendObj);

  List _messageList = [];

  TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  String _sendText = '';
  var _rateHeight,_rateWidth;

  @override
  void initState() {
    friendObj.userObj = friendObj.getName();
    _myData.userObj = _myData.getName();

    // TODO: implement initState
    _LinkSocket();
    super.initState();
  }
  _LinkSocket() async {

    var item;
    List<String> _tempList = [_myData.uuid,friendObj.uuid];
    _tempList.sort();
    String roomNum = '';
    for(var i in _tempList)
      roomNum = roomNum + i;

    item = jsonEncode({
      // 'user1': _myData.userObj,
       'user1': "visionwill",
      // 'user2': friendObj.userObj,
      'user2': "jjuho",
      'roomNum': "123444", 
    });

    socket = await IO.io(_socket_api, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('connect');
      socket.emit('enter-room', item); // chatting room
    });
    socket.on('msglist', (str) => print(str)); // 처음 진입 시
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (str) => print(str));
    socket.on(ServerData.KeyList['msg'] as String, (msg)  {
      print('server send msg: ${msg}');
      setState(() {
        _messageList.add(msg);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    _rateHeight = MediaQuery.of(context).size.height / 100;
    _rateWidth = MediaQuery.of(context).size.width / 100;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(friendObj.getName()),
        primary: true,
        actions: <Widget>[
          IconButton(onPressed: (){Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);}, icon: Icon(Icons.home,size: 30,))
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Flexible(
            child: ListView(
              controller: _scrollController,
              children: [
                for(var item in _messageList)
                  _addMessageWidget(item),
              ],
              semanticChildCount: _messageList.length,
            ),
          ),
          _SendTextForm(),
        ],
      ),
    );
  }

  Widget _addMessageWidget(item){
    var _item = jsonDecode(item);

    String msg = _item[ServerData.KeyList['msg']];
    bool _isMe = (_item[ServerData.KeyList['user']] == _myData.userObj);

    if(_isMe)
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
              child: Text(msg, style: TextStyle(color: Colors.white, fontSize: 13,),),
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
                color:Colors.blueAccent,
              ),
              child: Text(
                msg, style: TextStyle(color: Colors.white, fontSize: 13,),),
              padding: EdgeInsets.all(8),
            )
          ],
        ),
        padding: EdgeInsets.fromLTRB(3, 4, 2, 3),
      );
    }
  }

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
              )
          )
      ),
      width: _rateWidth*100,
      height: 45,
      child: Center(child:
        Wrap(
          children: [
            Container(
              width: _rateWidth*80,
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
              onPressed: (){
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
      )
    );
}