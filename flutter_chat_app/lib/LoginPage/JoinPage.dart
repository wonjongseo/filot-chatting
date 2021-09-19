import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/ServerData.dart';

import 'package:http/http.dart' as http;

String icon_path = 'image/teamIcon.png';

class JoinPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JoinPage();
}
<<<<<<< HEAD:flutter_chat_app/lib/LoginPage/JoinPage.dart
class _JoinPage extends State<JoinPage>{

  /// 회원가입 api
  String _Join_api = ServerData.api+(ServerData.ApiList['/join'] as String);//"여기에 api";

  /// input text를 보여주기 위한 list, 이 List에 요소를 추가하면 입력란이 생성된다.
  List _TextFormList = ['아이디','비밀번호','비밀번호 확인','이름', '역할','전화번호'];
  Map<String,String> _InfoList = {};
  /// 위 Map 함수에 사용될 Key List, 이를 추가해주어야 정상적으로 json 형태로 데이터들이 parsing 된다.
  List _InfoLists = ['id','pwd','checkpwd','name', 'role','phone'];
  /// Text Controller List, 이는 위의 요소들에 의해 자동으로 생성된다.
=======

class _JoinPage extends State<JoinPage> {
  String _Join_api = "http://localhost:9999/join";
  String ID = '', Password = '';

  List _TextFormList = ['아이디', '비밀번호', '비밀번호 확인', '이름', '닉네임', '전화번호'];
  List<String> _InfoList = [];
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87:flutter_chat_app/lib/JoinPage.dart
  List<TextEditingController> values = [];


  /// Password의 validation을 확인한다.
  String? validatePassword(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return null;
  }

  @override   /// 이 컨텍스트가 실행되면서 초기화 메소드, controller를 생성한다.
  void initState() {
    // TODO: implement initState
    super.initState();

    for (var item in _TextFormList) {
      values.add(TextEditingController());
    }
  }

<<<<<<< HEAD:flutter_chat_app/lib/LoginPage/JoinPage.dart
  /// 실제 Text Form 필드를 생성하는 메소드
  Padding _makeTextFormField(int index, bool obscure){
=======
  Padding _makeTextFormField(int index, bool obscure) {
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87:flutter_chat_app/lib/JoinPage.dart
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 5),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: values[index],
            keyboardType: TextInputType.text,
            obscureText: obscure,
            decoration: InputDecoration(
                labelText: _TextFormList[index],
                labelStyle: TextStyle(
                  fontFamily: 'bmjua',
                  fontSize: 14,
                )),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Text is empty';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD:flutter_chat_app/lib/LoginPage/JoinPage.dart
  /// 회원가입 중 에러가 발생할 경우 팝업창을 띄우는 메소드
  void _errorPopup(String str){
=======
  void _errorPopup(String str) {
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87:flutter_chat_app/lib/JoinPage.dart
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error!"),
          content: new Text(str),
          actions: <Widget>[
            ElevatedButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

<<<<<<< HEAD:flutter_chat_app/lib/LoginPage/JoinPage.dart
  /// 서버와 api 통신을 위한 메소드, 회원가입을 수행함
  void _join() async{
=======
  void _join() async {
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87:flutter_chat_app/lib/JoinPage.dart
    final response = await http.post(
      Uri.parse(_Join_api),
      body: jsonEncode(
        {
<<<<<<< HEAD:flutter_chat_app/lib/LoginPage/JoinPage.dart
          for(var item in _InfoList.entries)
            ServerData.KeyList[item.key] : item.value,
=======
          'id': _InfoList[0],
          'pwd': _InfoList[1],
          'pwd2' : _InfoList[2],
          'name': _InfoList[3],
          'nickname': _InfoList[4],
          'phone': _InfoList[5],
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87:flutter_chat_app/lib/JoinPage.dart
        },
      ),
      headers: {'Content-Type': "application/json"},
    );
<<<<<<< HEAD:flutter_chat_app/lib/LoginPage/JoinPage.dart
    if(response.statusCode >= 200 && response.statusCode < 300) {
=======
    if (response.statusCode == 200) {
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87:flutter_chat_app/lib/JoinPage.dart
      // check Join Success and return
      Navigator.of(context).pop();
      return;
    }

    /// Join failed, and popup Failed
    _errorPopup(jsonDecode(response.body)[ServerData.KeyList!['msg']].toString());
  }

  @override /// 실제 화면을 build하는 메소드
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 30)),
            Text("FILOT",
                style: TextStyle(
                  fontFamily: 'bmjua',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: <Widget>[
                  _makeTextFormField(0, false),
                  _makeTextFormField(1, true),
                  _makeTextFormField(2, true),
                  _makeTextFormField(3, false),
                  _makeTextFormField(4, false),
                  _makeTextFormField(5, false),
                ],
              ),
            ),
            ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[Text("인증하기")],
                ),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white60,
                  padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
                ),
                onPressed: () {
<<<<<<< HEAD:flutter_chat_app/lib/LoginPage/JoinPage.dart
                  for(int index = 0; index<values.length;index++){
                    var str = values[index].text.toString();
                    if(str.isEmpty) {
                      _errorPopup("빈 칸이 없어야 합니다!");
                      return;
                    }
                    else
                      _InfoList.addAll({_InfoLists[index]: str});
=======
                  for (var item in values) {
                    var str = item.text.toString();
                    if (str.isEmpty) {
                      _errorPopup("빈 칸이 없어야 합니다!");
                      return;
                    } else
                      _InfoList.add(str);
>>>>>>> 755b9de241b3015781b8351b48219a83f07d6d87:flutter_chat_app/lib/JoinPage.dart
                  }

                  if (_InfoList[1] != _InfoList[2]) {
                    _errorPopup("비밀번호가 일치하지 않습니다!");
                    return;
                  }

                  setState(() {
                    for (var i = 0; i < values.length; i++) values[i].clear();
                  });
                  _join();
                }),
            Padding(padding: EdgeInsets.all(13)),
          ],
        ),
      ),
    );
  }
}
