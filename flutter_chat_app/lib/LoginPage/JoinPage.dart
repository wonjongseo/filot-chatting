import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;


String icon_path = 'image/teamIcon.png';

class JoinPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _JoinPage();
}
class _JoinPage extends State<JoinPage>{
  String _Join_api = "https://en5f3ghmodccnhn.m.pipedream.net";
  String ID='', Password='';

  List _TextFormList = ['아이디','비밀번호','비밀번호 확인','이름', '닉네임','전화번호'];
  List<String> _InfoList = [];
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

  Padding _makeTextFormField(int index, bool obscure){
    return Padding(
        padding: EdgeInsets.fromLTRB(15,20,15,5),
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

  void _join() async{
    final response = await http.post(
      Uri.parse(_Join_api),
      body: jsonEncode(
        {
          'id': _InfoList[0],
          'pwd': _InfoList[1],
          'name': _InfoList[3],
          'nickname': _InfoList[4],
          'phone': _InfoList[5],
        },
      ),
      headers: {'Content-Type': "application/json"},
    );
    if(response.statusCode == 200) {
      // check Join Success and return
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => InfoCheck()));
      Navigator.of(context).pop();
      return;
    }

    // Join failed, and popup Failed
    _errorPopup("생성 중 에러가 발생했습니다.\n(ID중복 또는 패스워드 불일치)");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Page"),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Padding(padding: EdgeInsets.fromLTRB(0,30,0,30)),
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
                  _makeTextFormField(0,false),
                  _makeTextFormField(1,true),
                  _makeTextFormField(2,true),
                  _makeTextFormField(3,false),
                  _makeTextFormField(4,false),
                  _makeTextFormField(5,false),
                ],
              ),
            ),
            ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("인증하기")
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  onPrimary:Colors.white60,
                  padding: EdgeInsets.fromLTRB(80,0,80,0),
                ),
                onPressed: () {
                  for(var item in values){
                    var str = item.text.toString();
                    if(str.isEmpty) {
                      _errorPopup("빈 칸이 없어야 합니다!");
                      return;
                    }
                    else
                      _InfoList.add(str);
                  }

                  if(_InfoList[1] != _InfoList[2]){
                    _errorPopup("비밀번호가 일치하지 않습니다!");
                    return;
                  }

                  setState(() {
                    for(var i = 0;i<values.length;i++)
                      values[i].clear();
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
