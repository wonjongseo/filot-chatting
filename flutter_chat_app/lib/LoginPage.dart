import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/FindClientInfo.dart';
import 'package:flutter_chat_app/JoinPage.dart';

import 'package:http/http.dart' as http;

String icon_path = 'image/teamIcon.png';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPage();
}
class _LoginPage extends State<LoginPage>{
  String _Login_api = "https://en5f3ghmodccnhn.m.pipedream.net";
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();
  String ID='', Password='';
  var sum = '0';

  List _buttonList = ['아이디 또는 비밀번호 찾기','회원가입하기'];
  List _TextFormList = ['아이디','비밀번호'];

  TextButton _makeTextButton(int index){
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_buttonList[index],
            style: TextStyle(
                fontFamily: 'bmjua',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black87
            ),
          ),
        ],
      ),
      onPressed: () {
        if(index.isEven)
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => FindClientInfo()));
        else
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => JoinPage()));

      },
    );
  }
  TextFormField _makeTextFormField(int index, bool obscure){
    return TextFormField(
      controller: index.isEven ? value1 : value2,
      keyboardType: TextInputType.text,
      obscureText: obscure,
      decoration: InputDecoration(
          labelText: _TextFormList[index],
          labelStyle: TextStyle(
            fontFamily: 'bmjua',
            fontSize: 14,
          )
      ),
    );
  }

  Future<http.Response> _login(id, pwd) async{
    final response = await http.post(
      Uri.parse(_Login_api),
      body: jsonEncode(
        {
          'id': id,
          'pwd': pwd,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Text("FILOT",
                  style: TextStyle(
                    fontFamily: 'bmjua',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              Image.asset(icon_path, width: 200, height: 150, fit: BoxFit.fill),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: <Widget>[
                    _makeTextFormField(0,false),
                    _makeTextFormField(1,true),
                  ],
                ),
              ),
              ElevatedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Login")
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white60,
                    padding: EdgeInsets.fromLTRB(80,0,80,0),
                  ),
                  onPressed: () {
                    print('pressed');
                    setState(() {
                      ID = value1.value.text;
                      Password = value2.value.text;
                      value1.clear();
                      value2.clear();
                    });
                    _login(ID, Password);
                  }),
              Padding(padding: EdgeInsets.all(13)),
              _makeTextButton(0),
              _makeTextButton(1),


            ],
          ),
        ),
      ),
    );
  }
}