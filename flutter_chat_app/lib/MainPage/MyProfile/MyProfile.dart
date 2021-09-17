import 'dart:convert';

//import 'package:client_cookie/client_cookie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/data/MyData.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// 이미지 경로
String icon_path = 'image/teamIcon.png';
String github_outline_path = 'image/github_outline.png';
String github_path = 'image/github.png';
String role_path = 'image/role.jpg';
String state_path = 'image/state.png';

class MyProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyProfile();
}

class _MyProfile extends State<MyProfile> {

  /*------------------ 변수 선언 구문 ------------------*/
  /// 내 데이터들을 불러오는 api / state를 실시간 변경됨을 소통하는 api --server
  final MyProfile_api = ServerData.api + (ServerData.ApiList['/myprofile'] as String);
  final state_socket_api = ServerData.api + (ServerData.ApiList['/state'] as String);

  /// socket 변수 생성  --server
  late IO.Socket socket;

  /// 공지사항 리스트, 공지사항들을 불러와서 저장하되, 현재는 미사용
  List _NoticeList = [];
  /// UI용 Icon List
  Map<String,Widget> _IconList = {
    "State":Image.asset(state_path,width: 45,height: 45,),
    "Role":Image.asset(role_path,width: 40,height: 40,),
    "Github":Image.asset(github_path,width: 40,height: 40,),
    "Email":Icon(Icons.mail,size: 40,color: Colors.black,),
    "Phone":Icon(Icons.smartphone,size: 40,color: Colors.black,),
  };
  /// 내 현재 상태를 알리는 변수, 각각 [ 연락 가능, 연락 불가, 연락 임시 가능 ]을 의미함
  List<bool> _currentStates = [true,false,false];
  List<Color> _stateColorList = [Colors.green, Colors.red, Colors.blue];

  /// 내 정보 ( 역할, 깃헙 사이트, email, 전화번호 ) 등을 수정할 수 있는 text controller
  /// 이 정보가 수정됨을 확인하기 위해 controller를 생성했다.
  Map<String,TextEditingController> _TextEditController = {
    "Role":new TextEditingController(),
    "Github":new TextEditingController(),
    "Email":new TextEditingController(),
    "Phone":new TextEditingController(),
  };

  /// 내 정보 데이터 저장 변수
  MyData _myData = new MyData(ServerData.adminItem);

  /// 기기 사이즈를 저장하는 변수
  var deviceHeight, deviceWidth;
  /*--------------------------------------------------*/

  /*------------------ 위젯 생성 메서드 구문 ------------------*/
  /// 내 정보를 보여주고 또 변경할 수 있는 text context를 생성해준다.
  /// 타입을 받아서 state, github, email, phone number를 변경 및 표현한다.
  Widget _makeProfileState(String type){
    final rateWidth = deviceWidth/100;
    return Container(
      height: 65,
      width: rateWidth*68,
      child: Row(
        children: [
          Center(child: _IconList[type]),
          Expanded(child: Container(
            child: Center(child: type == 'State' ? _currentState():_EditTextForm(_TextEditController[type]),),
          ),)
        ],
      ),
    );
  }

  /// 현재 내 상태 _currentStates[] 에 따른 UI를 표현하는 위젯 메소드, decobox는 아래 함수가 너무 길어져 분리한 꾸미기 메소드
  /// _makeProfileState에서 routing 되어 사용된다. (type == state)
  Widget _currentState(){
    final _widthRate = deviceWidth / 100;
    return Wrap(
      children: [
        GestureDetector(
          child: Container(
            width: _widthRate*12,
            height: 30,
            decoration: _currentStateDecoBox(Colors.green,_currentStates[0]),
          ),
          onTap: _currentStates[0]?(){}:(){
            _updateState(0);
          },
        ),
        Padding(padding: EdgeInsets.fromLTRB(_widthRate*5,0,0,0)),
        GestureDetector(
          child: Container(
            width: _widthRate*12,
            height: 30,
            decoration: _currentStateDecoBox(Colors.red,_currentStates[1]),
          ),
          onTap: _currentStates[1]?(){}:(){
            _updateState(1);
          },
        ),
        Padding(padding: EdgeInsets.fromLTRB(_widthRate*5,0,0,0)),
        GestureDetector(
          child: Container(
            width: _widthRate*12,
            height: 30,
            decoration: _currentStateDecoBox(Colors.blue,_currentStates[2]),
          ),
          onTap: _currentStates[2]?(){}:(){
            _updateState(2);
          },
        ),

      ],
    );
  }
  BoxDecoration _currentStateDecoBox(Color color, [flag]){
    if(flag){
      return BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black87.withOpacity(0.7),
          ),
          BoxShadow(
            color: color,
            spreadRadius: -3.0,
            blurRadius: 6.0,
            offset: Offset(0, 0),
          ),
        ],
        border: Border.all(
          color: color,
          width: 0.1
        )
      );
    }
    else {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color,
          border: Border.all(
            color: Colors.black12,
            width: 1,
          )
      );
    }
  }

  /// state를 제외한 text 입력 폼을 생성해주는 위젯 메소드
  /// _makeProfileState에서 routing 되어 사용된다. (type != state)
  Widget _EditTextForm(TextEditingController? controller,[str]){

    final _rateWidth = deviceWidth / 100;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black54,
          )
        )
      ),
      width: _rateWidth*55,
      height: 40,
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          labelStyle: TextStyle(
            fontSize: 15,
          )
        ),
        controller: controller,
        onSaved: (val){
          print("saved");
        },
        onChanged: (val){},
        textInputAction: TextInputAction.go,
        onFieldSubmitted: (value)async{
          _myData.setRole(_TextEditController["Role"]!.text);
          _myData.setGithub(_TextEditController["Github"]!.text);
          _myData.setEmail(_TextEditController["Email"]!.text);
          _myData.setPhone(_TextEditController["Phone"]!.text);
          _updateData();
          _getData();
        },
      ),

    );
  }

  /// 가장 상단에 보여지는 내 프로필을 보여주는 위젯 메소드, 길이와 높이를 받아 표현한다.
  Widget _ProfileCardeView(width, height){
    var _widthRate = width * 0.01;
    var _hegihtRate = height * 0.01;
    // 추후 User Data를 받아오는 파라미터 필요
    // 현재 위젯의 너비와 높이를 받아와서 비율을 계산
    return Container(
      width: _widthRate*85,
      height: _hegihtRate*80,
      child: Row(
        children: [
          // profile image
          Container(
              width: _widthRate*25,
              height: _widthRate*25,
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
                      Text(_myData.getName(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      Padding(padding: EdgeInsets.all(3)),
                      Container(
                        width: _widthRate*23.1,
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.all(6)),
                            Text(_myData.getRole(),style: TextStyle(fontSize: 12))
                          ],
                        ),
                      ),
                      Container(
                        width: _widthRate*8,
                        height: _hegihtRate*14,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: _stateColorList[_myData.getState()],
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
                      GestureDetector(
                        onTap: () => _launchURL(_myData.getGithub()),
                        child: Image.asset(github_outline_path,width: 20,height: 20,),
                      ),

                      //Image.asset(github_outline_path,width: double.infinity,height: double.infinity,),
                      Padding(padding: EdgeInsets.all(5),),
                      GestureDetector(
                        onTap: () => _launchMail(_myData.getEmail()),
                        child:  Icon(Icons.mail_outline,size: 20,),
                      ),
                      Padding(padding: EdgeInsets.all(5),),
                      GestureDetector(
                        onTap: () => _launchPhone(_myData.getPhone()),
                        child:  Icon(Icons.phone,size: 20,),
                      ),
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
  /// 프로필 바로 하단에 보여지는 공지사항 메소드, 공지사항을 불러와 보여준다.
  Widget _Notice([object]){
    //Notice Object가 필요하다.
    //Notice object에는 내용과 제목, 작성자, 날짜 등이 있다.
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black87,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.all(10),),
          Text("Hello?")
        ],
      ),
    );
  }

  /// 하단 text를 수정한다.
  void _updateUiText(){
    /// 아래는 UI적 요소
    _TextEditController["Role"]!.text =  _myData.getRole();
    _TextEditController["Github"]!.text =  _myData.getGithub();
    _TextEditController["Email"]!.text =  _myData.getEmail();
    _TextEditController["Phone"]!.text =  _myData.getPhone();
  }

  @override /// 실제 화면을 build하는 메소드
  Widget build(BuildContext context) {

    /** 실제 계산 과정 **/
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    final rateWidth = (deviceWidth - 80)/100;
    final rateHeight = (deviceHeight)/100;

    var MyProfileWidgetWidth, MyProfileWidgetHeight;
    /** 여기까지 **/

    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              /** 내 현재 프로필 상태 Container**/
              Container(
                child: Center(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.all(rateHeight*3)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black12,
                            width: 1,
                          ),
                          borderRadius: const BorderRadius.all(const Radius.circular(8)),
                          boxShadow: [BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(2, 3),
                          )],

                        ),
                        width: (MyProfileWidgetWidth=rateWidth * 90),
                        height: (MyProfileWidgetHeight=100.0),
                        child: Center(child: _ProfileCardeView(MyProfileWidgetWidth,MyProfileWidgetHeight)),
                      ),

                    ],
                  ),

                ),
                height: rateHeight*20,
              ),

              /** 공지사항 Container**/
              Container(
                height: rateHeight*30,
                child: Column(
                  children: [
                    Container(
                      height: rateHeight*6.5,
                      width: rateWidth*85,
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        height: rateHeight*5.0,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black12,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          direction: Axis.vertical,
                          children: [
                            Icon(Icons.star,color: Colors.yellow,),
                            Text("공지사항",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(3),),
                    Expanded(child: Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black12,
                          width: 1,
                        ),
                        boxShadow: [BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(2, 3),
                        )],
                        borderRadius: const BorderRadius.all(const Radius.circular(5)),
                      ),
                      height: double.infinity,
                      width: rateWidth*80,
                      child: Column(
                        children: [
                          _Notice(),
                          for(var item in _NoticeList)
                            _Notice(),
                        ],
                      ),
                    ))

                  ],
                ),
              ),

              /** 내 프로필 수정 Container**/
              Container(
                height: rateHeight*50,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _makeProfileState("State"),
                      _makeProfileState("Role"),
                      _makeProfileState("Github"),
                      _makeProfileState("Email"),
                      _makeProfileState("Phone"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
  /*--------------------------------------------------*/

  /*------------------ 데이터 처리 메서드 구문 ------------------*/
  // 아래 모든 데이터 메소드는 서버 관련 메소드 --server
  @override  /// 이 컨텍스트가 실행되면서 초기화 메소드, 내 data를 불러오고 Socket을 Link 한다..
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    _LinkSocket();
  }
  /// 실제 내 데이터를 불러오는 메소드, header에 발급받은 token을 넣어 보낸다. METHOD = GET
  void _getData() async{
    // 모든 정보를 업데이트 한다.
    var _tokenValue = myData.getToken();

    Map<String, String> header = {
      'Content-Type': "application/json",
      ServerData.KeyList['token'] as String : _tokenValue,
    };
    final response = await http.get(
        Uri.parse(MyProfile_api),
        headers: header
    );

    if(response.statusCode < 200 || response.statusCode >= 300){
      return;
    }

    myData.userObj = response.body;

    if(myData.parsingData())
      print("parsing was successful");
    else
      throw Exception("parsing error: response body is empty");

    _myData = myData;

    /** 화면에 뿌리기 **/
    _TextEditController["Role"]!.text =  _myData.getRole();
    _TextEditController["Github"]!.text =  _myData.getGithub();
    _TextEditController["Email"]!.text =  _myData.getEmail();
    _TextEditController["Phone"]!.text =  _myData.getPhone();
    _StateWidgetUpdate(_myData.getState());
  }
  /// 변경된 내 데이터를 서버에 전송한다.
  void _updateData() async {
    print(await _myData.UpdateData()); // --server MyData 클래스 내장 함수 update를 통해 프로필 갱신을 한다.
    _updateUiText();
  }

  /// 변경된 내 상태를 실시간 서버에 전송한다.
  void _updateState(int index) async {
    myData.setState(index);
    print(socket.connected);
    if(socket.connected) {
      var item = jsonEncode({
        'name': myData.getName(), // name 전송 string
        'state': myData.getState(),
      });
      socket.emit('set_state', item);

      _StateWidgetUpdate(index);
    }
  }
  void _StateWidgetUpdate(int index){
    for(var idx = 0; idx < _currentStates.length; idx++) {
      _currentStates[idx] = (idx == index);
      _myData.setState(index);
    }
    setState(() {});
  }
  /// 실제 Socket을 연결하는 메소드 / 성공적으로 데이터를 불러왔을 때 Socket을 연결한다.
  _LinkSocket() async {
    print("Linking Socket... ");
    socket = await IO.io(state_socket_api, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((str) {
      // server socket connect
      print("myprofile state : conntected");
      print(socket.connected);
      print(socket.disconnected);
    });
    socket.onReconnect((str) {
      // server socket reconnect
      print("myprofile state : reconnected");
      print(socket.connected);
      print(socket.disconnected);
    });
    socket.onDisconnect((data) => print('myprofile state : disconnect'));
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
  /** 메소드 **/
  /*--------------------------------------------------*/
}