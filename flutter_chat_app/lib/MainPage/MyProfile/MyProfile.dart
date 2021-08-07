import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/data/MyData.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

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
  final GET_MyProfile_api = ServerData.api + (ServerData.ApiList['/myprofile'] as String);

  String strs = '';
  List _NoticeList = [];
  Map<String,Widget> _IconList = {
    "State":Image.asset(state_path,width: 45,height: 45,),
    "Role":Image.asset(role_path,width: 40,height: 40,),
    "Github":Image.asset(github_path,width: 40,height: 40,),
    "Email":Icon(Icons.mail,size: 40,color: Colors.black,),
    "Phone":Icon(Icons.smartphone,size: 40,color: Colors.black,),
  };
  List<bool> _currentStates = [true,false,false];
  Map<String,TextEditingController> _TextEditController = {
    "Role":new TextEditingController(),
    "Github":new TextEditingController(),
    "Email":new TextEditingController(),
    "Phone":new TextEditingController(),
  };

  late MyData _myData;

  var deviceHeight, deviceWidth;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    final rateWidth = (deviceWidth - 80)/100;
    final rateHeight = (deviceHeight)/100;

    var MyProfileWidgetWidth, MyProfileWidgetHeight;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();

  }
  void _getData() async{

    // 모든 정보를 업데이트 한다.
    var _tokenValue;
    try {
      _tokenValue = (await storage.read(key: 'token'))!;
    }catch (e){
      print(e.toString());
    }

    final response = await http.get(
        Uri.parse(GET_MyProfile_api),
        headers: {'Content-Type': "application/json",
          ServerData.KeyList['token'] as String : _tokenValue,
        }
    );
    if(response.statusCode < 200 || response.statusCode >= 300){
      return;
    }

    var data = jsonDecode(response.body);
    myData = new MyData(data[ServerData.KeyList['name']]);
    myData.setRole(data[ServerData.KeyList['role']]);
    myData.setPhone(data[ServerData.KeyList['phone']]);
    myData.setEmail(data[ServerData.KeyList['email']]);
    myData.setGithub(data[ServerData.KeyList['github']]);

    _myData = myData;

    /** 화면에 뿌리기 **/
    _TextEditController["Role"]!.text =  _myData.getRole();
    _TextEditController["Github"]!.text =  _myData.getGithub();
    _TextEditController["Email"]!.text =  _myData.getEmail();
    _TextEditController["Phone"]!.text =  _myData.getPhone();
  }
  void _updateData() async {
    print(await _myData.UpdateData());
  }

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
            setState(() {
              _currentStates[0] = true;
              _currentStates[1] = false;
              _currentStates[2] = false;
              _updateData();
              _getData();
            });
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
            setState(() {
              _currentStates[0] = false;
              _currentStates[1] = true;
              _currentStates[2] = false;
              _updateData();
              _getData();
            });
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
            setState(() {
              _currentStates[0] = false;
              _currentStates[1] = false;
              _currentStates[2] = true;
              _updateData();
              _getData();

            });
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
          print(value.toString());
          _updateData();
          _getData();
        },
      ),

    );
  }

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

  Widget _ProfileCardeView(width, height, [object]){
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
                      Text("이주호",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      Padding(padding: EdgeInsets.all(3)),
                      Container(
                        width: _widthRate*23.1,
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.all(6)),
                            Text("Front End",style: TextStyle(fontSize: 12))
                          ],
                        ),

                      ),

                      Container(
                        width: _widthRate*8,
                        height: _hegihtRate*14,
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
                      GestureDetector(
                        onTap: () => _launchURL('https://flutter.io'),
                        child: Image.asset(github_outline_path,width: 20,height: 20,),
                      ),

                      //Image.asset(github_outline_path,width: double.infinity,height: double.infinity,),
                      Padding(padding: EdgeInsets.all(5),),
                      GestureDetector(
                        onTap: () => _launchMail('test@gmail.com'),
                        child:  Icon(Icons.mail_outline,size: 20,),
                      ),
                      Padding(padding: EdgeInsets.all(5),),
                      GestureDetector(
                        onTap: () => _launchPhone('01076687785'),
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
}