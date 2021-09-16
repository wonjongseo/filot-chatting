import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/MainPage/MyProfile/MyProfile.dart';
import 'package:flutter_chat_app/data/FrinedsData.dart';
import 'package:flutter_chat_app/data/MyData.dart';
import 'package:flutter_chat_app/data/ProfileData.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

class Chatting extends StatefulWidget{

  List<FrinedsData>  friendsObjs;
  Chatting({Key? key, required this.friendsObjs}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Chatting(friendsObjs);
}

String icon_path = 'image/teamIcon.png';
String github_outline_path = 'image/github_outline.png';
String github_path = 'image/github_outline.png';

class _Chatting extends State<Chatting>{

  /*------------------ 변수 선언 구문 ------------------*/
  /// 소켓 접속을 위한 api
  final _socket_api = ServerData.api + "/"; //ServerData.api + '/see'; //10.0.2.2

  /// socket 변수 생성
  late IO.Socket socket;

  /// 친구 데이터와 내 데이터를 초기화
  List<FrinedsData> _frinedsList;
  late FrinedsData friendObj;
  MyData _myData = myData;
  _Chatting(this._frinedsList);

  /// Chatting room number
  late String roomNum;

  /// 메시지에 대한 리스트, 이 순서대로 레이아웃이 펼쳐진다.
  List _messageList = [];

  /// UI용 Icon List
  Map<String,Widget> _IconList = {
    "Github":FittedBox(child: Image.asset(github_path,fit: BoxFit.fitHeight,color: Colors.white,),fit: BoxFit.fill,),
    "Email":Icon(Icons.mail,color: Colors.white,),
    "Phone":Icon(Icons.smartphone,color: Colors.white,),
    "Chat":Icon(Icons.chat_bubble,color: Colors.white,),
  };

  /// 텍스트 controller와 화면을 scroll 할 수 있는 controller
  TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  String _sendText = '';

  /// 기기 사이즈를 받고, 비율을 지정
  var _rateHeight,_rateWidth;
  var deviceHeight, deviceWidth;
  /*--------------------------------------------------*/

  /*------------------ 위젯 생성 메서드 구문 ------------------*/
  /// _messageList에서 요소를 받아 실제 UI를 그리는 위젯 추가 메서드
  Widget _addMessageWidget(item){
    var _item = item is String ? jsonDecode(item) : item;

    String msg = _item[ServerData.KeyList['msg']];
    bool _isMe = (_item[ServerData.KeyList['user']] == _myData.getName());

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
                  ServerData.KeyList['user']: _myData.getName(),
                  'roomNum': roomNum,
                });
                if(socket.connected) {
                  socket.emit(ServerData.KeyList['msg'] as String, item);
                  _messageList.add(item);
                }
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

  @override /// 실제 화면을 build하는 메소드
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _rateHeight = deviceHeight/ 100;
    _rateWidth = deviceWidth / 100;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(friendObj.getName()),
        primary: true,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,size: 30,)),
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
      endDrawer: Drawer(
        child: Container(
          // Important: Remove any padding from the ListView.
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    )),
                margin: EdgeInsets.zero,
                accountEmail: Text(_myData.getEmail()),
                accountName: Text(_myData.getName()),
                currentAccountPicture: Container(
                    width: _rateWidth*30,
                    height: _rateWidth*30,
                    child: Image.asset(_myData.getImage(), fit: BoxFit.fill,),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(const Radius.circular(100)),
                    )
                ),
              ),
              Expanded(child: Column(
                children: [
                  ListTile(
                    title: Center(
                      child: Row(
                        children: [
                          Icon(Icons.add_circle_outline_outlined,size: 25,color: Colors.blue,),
                          Padding(padding: EdgeInsets.all(3)),
                          Text("대화 상대 추가하기"),
                        ],
                      ),
                    ),
                    onTap: () {
                      /// 여기에 따로 클래스 만들어
                      /// 팝업 만들거,> 대화상대 추가하는 기능
                      /// 이 때, 필요한 것은 친구 데이터를 같이 넘기는 것이 중요!
                      /// [여기에 있는 친구 obj-> null일 수 있음, 추가할 친구 명]
                      /// 받은 곳에서는 먼저 친구 리스트에 친구 데이터를 추가한다. ( not null)
                      /// 서버에 친구 객체를 요청 및 생성 후 방 생성
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: _addUser(_myData),
                  ),
                  Divider(),
                  for(var item in _frinedsList)
                    ListTile(
                      title: _addUser(item),
                      onTap: () {
                        _frinedPopup(item);
                      },
                    ),
                ],
              )),
              Container(
                  child: Align(
                      alignment: FractionalOffset.bottomRight,
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          Row(
                            children: [
                              IconButton(onPressed: (){Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);}, icon: Icon(Icons.home,size: 25,color: Colors.blue,))
                            ],
                            mainAxisAlignment: MainAxisAlignment.end,
                          )
                        ],
                      ))),
            ],
          )

        ),

      ),
    );
  }
  void _frinedPopup(FrinedsData UserObj){
    double _nameSize;
    double _paddingSize,_iconSize;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(child: IconButton(icon: Icon(Icons.clear), onPressed: () { Navigator.of(context).pop(); },color: Colors.white,), alignment: Alignment.topLeft,),
          content: Container(
            width: deviceWidth,
            height: _rateHeight*90,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    width: _rateWidth*30,
                    height: _rateWidth*30,
                    child: Image.asset(icon_path, fit: BoxFit.fill,),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(const Radius.circular(100)),
                    )
                ),
                Padding(padding: EdgeInsets.all(8),),
                Container(
                  child: Center(child: Text(UserObj.getName(),style: TextStyle(color: Colors.white,fontSize: (_nameSize = 17),fontWeight: FontWeight.bold),),),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  height: _nameSize*2,
                  width: _nameSize*5,
                ),
                Padding(padding: EdgeInsets.all(5),),
                Text(UserObj.getRole(),style: TextStyle(color: Colors.white,fontSize: (_nameSize = 15),),),
                Divider(color: Colors.white.withOpacity(1),thickness: 1,height: 50,),
                Container(
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 70,
                        child: GestureDetector(
                          child: Center(child: Column(
                            children: [
                              Container(child: _IconList["Github"], height: (_iconSize=50),),
                              Text("Github",style: TextStyle(color: Colors.white),),
                            ],
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),),
                          onTap: (){_launchURL(UserObj.getGithub());},
                        ),
                      ),
                      Padding(padding: EdgeInsets.all((_paddingSize=_rateWidth*5)),),
                      Container(
                        height: 70,
                        child: GestureDetector(
                          child: Center(child: Column(
                            children: [
                              Container(child: _IconList["Email"], height: _iconSize,),
                              Text("Email",style: TextStyle(color: Colors.white),),
                            ],
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),),
                          onTap: (){_launchMail(UserObj.getEmail());},
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(_paddingSize),),
                      Container(
                        height: 70,
                        child: GestureDetector(
                          child: Center(child: Column(
                            children: [
                              Container(child: _IconList["Phone"], height: _iconSize,),
                              Text("Phone",style: TextStyle(color: Colors.white),),
                            ],
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),),
                          onTap: (){_launchPhone(UserObj.getPhone());},
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(_paddingSize),),
                      Container(
                        height: 70,
                        child: GestureDetector(
                          child: Center(child: Column(
                            children: [
                              Container(child: _IconList["Chat"], height: _iconSize,),
                              Text("Talk",style: TextStyle(color: Colors.white),),
                            ],
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),),
                          onTap: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Chatting(friendsObjs: [UserObj])));},
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(10),),
              ],
            ),
          ),
          backgroundColor: Colors.transparent.withOpacity(0),

        );
      },
    );
  }
  /*--------------------------------------------------*/

  /*------------------ 데이터 처리 메서드 구문 ------------------*/
  // 아래 모든 데이터 메소드는 서버 관련 메소드 --server
  @override /// 이 컨텍스트가 실행되면서 초기화 메소드, Socket을 Link한다.
  void initState() {
    friendObj = _frinedsList.first;
    print(friendObj.getName());
    // TODO: implement initState
    _LinkSocket();
    super.initState();
  }
  /// 실제 Socket을 연결하는 메소드
  _LinkSocket() async {
    // 'username'
    var item;
    List<String> _tempList = [_myData.getName()];
    _frinedsList.forEach((element) {_tempList.add(element.getName());});

    _tempList.sort();
    roomNum = '';
    for(var i in _tempList)
      roomNum = roomNum + i;
    // adduser UI
    item = jsonEncode({
      'userList' : _tempList,
      'roomNum': roomNum,
    });

    socket = await IO.io(_socket_api, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((str) {
      print(str);
      print("chatting room socket connect");
      _messageList.clear();
      socket.emit(ServerData.KeyList['enter_room'] as String, item); // chatting room
      socket.connected = true;
    });

    socket.once(ServerData.KeyList['load-message'] as String, (data) {
      var _preMessageList = jsonDecode(data);
      for(var item in _preMessageList) // [ServerData.KeyList['chat']]
        _messageList.add(item);
      setState(() {});
    }); // 처음 진입 시

    socket.on(ServerData.KeyList['msg'] as String, (msg)  {
      print('server send msg: ${msg}');
      setState(() {
        _messageList.add(msg);
      });
    });
    socket.onDisconnect((data) {
      print('chatting room socket disconnect');
      _messageList.clear();
    });
  }
  @override
  void dispose(){
    socket.emit("room_num", "room out!!!");
    socket.dispose();
    super.dispose();
  }

  /** 각각의 정보 (github, mail, phone)을 실제 브라우저, 메일, 전화로 연결해줌 **/
  _launchURL(url) async {
    try {
      await launch(url, forceSafariVC: true, forceWebView: true);
    }catch(e){
      print(e.toString());
    }
  }
  _launchMail(mail) async{
    try {
      await launch("mailto:$mail");
    }catch(e){
      print(e.toString());
    }
  }
  _launchPhone(phoneNum) async{
    try {
      await launch("tel:$phoneNum");
    }catch(e){
      print(e.toString());
    }
  }
/*--------------------------------------------------*/
}