/*import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
String icon_path = 'image/teamIcon.png';
String github_outline_path = 'image/github_outline.png';
String github_path = 'image/github_outline.png';


class FriendsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsList();
}

class _FriendsList extends State<FriendsList> {
  List<Object> Users = [1,2,3,4,5,6,7,8,9,10];
  var deviceHeight, deviceWidth;

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
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    final rateWidth = (deviceWidth - 80)/100;
    final rateHeight = (deviceHeight)/100;
    var MyProfileWidget_width, MyProfileWidget_height;
    var FriendProfileWidget_width, FriendProfileWidget_height;
    // TODO: implement build
    return Scaffold(
        body: Column(
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
                      child: Center(child: _ProfileCardeView(MyProfileWidget_width,MyProfileWidget_height)),
                    ),
                  ],
                ),
              ),
              height: rateHeight*20,
            ),
            Container(height: 20,width: double.infinity, child: Center(child: Container( height: 1, width: rateWidth*80, color: Colors.black12),)),
            LayoutBuilder(
                builder: (BuildContext context,BoxConstraints viewportConstraints){
              return new SingleChildScrollView(
                child: Column(
                  children: [
                    for(var item in Users)
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
                          onTap: () {},
                          child: Center(child: _ProfileCardeView(
                              FriendProfileWidget_width,
                              FriendProfileWidget_height)),
                        ),
                      ),
                  ],
                ),
              );
            }
            ),

          ],
        ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
String icon_path = 'image/teamIcon.png';
String github_outline_path = 'image/github_outline.png';
String github_path = 'image/github_outline.png';


class FriendsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsList();
}

class _FriendsList extends State<FriendsList> {
  ScrollController _scrollController = new ScrollController();
  List<Object> Users = [1,2,3,4,5,6,7,8,9,10];
  var deviceHeight, deviceWidth;

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

  void _frinedPopup(String text, [String? title]){
    if(title == null)
      title = "Error!";
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 300,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          actions: <Widget>[
            /*ElevatedButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                }),*/
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    final rateWidth = (deviceWidth - 80)/100;
    final rateHeight = (deviceHeight)/100;
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
                        child: Center(child: _ProfileCardeView(MyProfileWidget_width,MyProfileWidget_height)),
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
                      for(var item in Users)
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
                            onTap: () {_frinedPopup("hi");},
                            child: Center(child: _ProfileCardeView(
                                FriendProfileWidget_width,
                                FriendProfileWidget_height)),
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
}
