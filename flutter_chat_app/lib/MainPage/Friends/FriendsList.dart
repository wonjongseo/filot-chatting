import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/MainPage/Chatting/ChattingRoom.dart';
import 'package:flutter_chat_app/data/FrinedsData.dart';
import 'package:flutter_chat_app/data/MyData.dart';
import 'package:flutter_chat_app/data/ProfileData.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

String icon_path = 'image/teamIcon.png';
String github_outline_path = 'image/github_outline.png';
String github_path = 'image/github_outline.png';


class FriendsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsList();
}

class _FriendsList extends State<FriendsList> {
  final _getUsersData_api = ServerData.api + '';

  Map<String,Widget> _IconList = {
    "Github":FittedBox(child: Image.asset(github_path,fit: BoxFit.fitHeight,color: Colors.white,),fit: BoxFit.fill,),
    "Email":Icon(Icons.mail,color: Colors.white,),
    "Phone":Icon(Icons.smartphone,color: Colors.white,),
    "Chat":Icon(Icons.chat_bubble,color: Colors.white,),
  };
  ScrollController _scrollController = new ScrollController();

  List<FrinedsData> _friends = [new FrinedsData('testing')];
  MyData _mydata = new MyData('juho');

  var deviceHeight, deviceWidth;
  var rateWidth, rateHeight;

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
  Widget _ProfileCardeView(width, height, UserData UserObj){
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
                  width: _widthRate*55,
                  height: _hegihtRate*33,
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Container(width: 70,child: Text(UserObj.getName(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,maxLines: 1,)),
                      Padding(padding: EdgeInsets.all(3)),
                      Container(
                        alignment: Alignment.bottomLeft,
                        width: 55,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.all(6)),
                            Flexible(child: Text(UserObj.getRole(),style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis,maxLines: 1,textWidthBasis: TextWidthBasis.parent,)),
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
                        onTap: () => _launchURL(UserObj.getGithub()),
                        child: Image.asset(github_outline_path,width: 20,height: 20,),
                      ),

                      //Image.asset(github_outline_path,width: double.infinity,height: double.infinity,),
                      Padding(padding: EdgeInsets.all(5),),
                      GestureDetector(
                        onTap: () => _launchMail(UserObj.getEmail()),
                        child:  Icon(Icons.mail_outline,size: 20,),
                      ),
                      Padding(padding: EdgeInsets.all(5),),
                      GestureDetector(
                        onTap: () => _launchPhone(UserObj.getPhone()),
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

  void _frinedPopup(UserData UserObj){
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
            height: rateHeight*90,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    width: rateWidth*30,
                    height: rateWidth*30,
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
                        Padding(padding: EdgeInsets.all((_paddingSize=rateWidth*5)),),
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
                            onTap: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Chatting(userObj: UserObj,)));},
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

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    rateWidth = (deviceWidth - 80)/100;
    rateHeight = (deviceHeight)/100;

    var MyProfileWidget_width, MyProfileWidget_height;
    var FriendProfileWidget_width, FriendProfileWidget_height;
    // TODO: implement build
    return Scaffold(
        body: //SingleChildScrollView( child:
        Column(
            children: <Widget> [
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
                        width: (MyProfileWidget_width=rateWidth * 90),
                        height: (MyProfileWidget_height=100.0),
                        child: Center(child: _ProfileCardeView(MyProfileWidget_width,MyProfileWidget_height,_mydata)),
                      ),
                    ],
                  ),
                ),
                height: rateHeight*20,
              ),
              Container(height: 20,width: double.infinity, child: Center(child: Container( height: 1, width: rateWidth*80, color: Colors.black12),)),
              Flexible(
                child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    controller: _scrollController,
                    children: [
                      for(var item in _friends)
                        Container(
                          height: (FriendProfileWidget_height = rateHeight * 15),
                          width: (FriendProfileWidget_width = rateWidth * 100),
                          decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Colors.black12,
                                    width: 1
                                ),
                              )
                          ),
                          child: GestureDetector(
                            onTap: () {_frinedPopup(item);},
                            child: Center(child: _ProfileCardeView(
                                FriendProfileWidget_width,
                                FriendProfileWidget_height,
                                item
                            )),
                          ),
                        ),
                    ]
                  //Column(children: [],),
                ),
              )
            ],
          ),
        //)
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
        Uri.parse(_getUsersData_api),
        headers: {'Content-Type': "application/json",
          ServerData.KeyList['token'] as String : _tokenValue,
        }
    );
    if(response.statusCode != 200){
      return;
    }
    var data;
    try {
      data = jsonDecode(response.body);
    }catch(e){
      print(e.toString());
    }
    try {
      print(data);
      for (var item in data) {
        FrinedsData _item = new FrinedsData(item[ServerData.KeyList['name']]);
        _item.setGithub(item[ServerData.KeyList['github']]);
        _item.setEmail(item[ServerData.KeyList['email']]);
        _item.setImage(item[ServerData.KeyList['image']]);
        _item.setPhone(item[ServerData.KeyList['phone']]);
        _item.setState(item[ServerData.KeyList['state']]);
        _item.userObj = item[ServerData.KeyList['user']];
        _friends.add(_item);
      }
    } catch (e) {
      print(e.toString());
    }

  }
  void _updateData() async {}
  
}
