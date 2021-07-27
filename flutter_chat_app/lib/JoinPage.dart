import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_app/FindClientInfo.dart';
import 'package:flutter_study_app/JoinPage.dart';
String icon_path = 'image/teamIcon.png';

class JoinPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _JoinPage();
}
class _JoinPage extends State<JoinPage>{
  String ID='', Password='';

  List _TextFormList = ['아이디','비밀번호','비밀번호 확인','이름', '닉네임'];
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
                ],
              ),
            ),
            RaisedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("인증하기")
                  ],
                ),
                color: Colors.white60,
                hoverColor: Colors.deepPurpleAccent,
                padding: EdgeInsets.fromLTRB(80,0,80,0),
                onPressed: () {
                  for(var item in values){
                    _InfoList.add(item.text.toString());
                  }
                  setState(() {});
                }),
            Padding(padding: EdgeInsets.all(13)),


          ],
        ),
      ),
    );
  }
}
