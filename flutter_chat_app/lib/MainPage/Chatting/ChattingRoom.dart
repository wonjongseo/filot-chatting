import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/ProfileData.dart';

class Chatting extends StatefulWidget{

  UserData  userObj;
  Chatting({Key? key,required this.userObj}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Chatting(userObj);
}
class _Chatting extends State<Chatting>{
  UserData  friendObj;
  _Chatting(this.friendObj);

  TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  String _sendText = '';
  var _rateHeight,_rateWidth;
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
              children: [],
            ),
          ),
          _SendTextForm(),
        ],
      ),
    );
  }

  Widget _SendTextForm([str]) {
    return Container(
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
                setState(() {
                  _textController.clear();
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
}