import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/ServerData.dart';

import 'package:http/http.dart' as http;

class FindClientInfo extends StatefulWidget{
  FindClientInfo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FindClientInfo();
}
class _FindClientInfo extends State<FindClientInfo>{
  /*******이부분 수정하면 됩니당********/
  String _Check_api = ServerData.api + (ServerData.ApiList['/find'] as String);
  List<String> _KeyList = ['id','password', 'confirmPassword','name','nickName','phone'];
  /*******이부분 수정하면 됩니당********/

  String ID = '';
  bool flag = false;
  List _TextFormList = ['아이디','비밀번호','비밀번호 확인', '닉네임','소개'];
  List _InfoList = [];
  List<TextEditingController> values = [];

  String? validatePassword(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(var item in _TextFormList) {
      values.add(TextEditingController());
    }
  }
  Container _makeText(String str, [fontSize]){
    try {
      if (fontSize == null)
        fontSize = 16.0;
    }
    catch(e){
      print("hello" + e.toString());
    }
    try {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Text(
                  str,
                  style: TextStyle(
                      fontFamily: 'bmjua',
                      fontSize: fontSize,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87
                  ),
                )
            ),
          ],
        ),
      );
    }
    catch(e){
      print("World " + e.toString());
    }
    return Container();
  }
  Padding _makeTextFormField(int index, bool obscure){
    return Padding(
      padding: EdgeInsets.fromLTRB(15,10,15,0),
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
                )
            ),
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

  void _errorPopup(String str){
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
  void _checking() async{
    final response = await http.get(
      Uri.parse(_Check_api+"?id="+ID),
      headers: {'Content-Type': "application/json"},
    );
    if(response.statusCode >= 200 && response.statusCode < 300) {
      _InfoList.clear();
      var dataConvertedToJSON = json.decode(response.body);

      for(var index = 0; index<_KeyList.length; index++)
        _InfoList.add("${dataConvertedToJSON[_KeyList[index]].toString()}");

      return;
    }

    // Join failed, and popup Failed
    _errorPopup("조회 중 에러가 발생했습니다.");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Modify Password"),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Padding(padding: EdgeInsets.fromLTRB(0,10,0,10)),
            Text("조회",
                style: TextStyle(
                  fontFamily: 'bmjua',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: <Widget>[
                  _makeText("아이디로 검색하기"),
                  _makeTextFormField(0,false),
                ],
              ),
            ),
            ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("조회하기")
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  onPrimary:Colors.white60,
                  padding: EdgeInsets.fromLTRB(80,0,80,0),
                ),
                onPressed: () {
                  ID = values[0].text.toString();
                  if(ID.isEmpty) {
                    _errorPopup("ID를 입력해 주세요");
                    return;
                  }
                  _checking();
                  setState(() {
                    flag = true;
                  });
                }),
            Padding(padding: EdgeInsets.all(13)),
            for(var i = 0;i<_InfoList.length;i++)
              flag ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.all(15)),
                  _makeText(_TextFormList[i], 15.0),
                  _makeText(_InfoList[i],15.0),
                ],
              )
                  : Padding(padding: EdgeInsets.zero),
          ],
        ),
      ),
    );
  }
}