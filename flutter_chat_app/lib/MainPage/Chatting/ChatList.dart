import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/MainPage/Chatting/ChattingRoom.dart';
import 'package:flutter_chat_app/data/ProfileData.dart';

String icon_path = 'image/teamIcon.png';
String github_outline_path = 'image/github_outline.png';
String github_path = 'image/github_outline.png';


class ChatList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatList();
}

class _ChatList extends State<ChatList> {
  ScrollController _scrollController = new ScrollController();
  List<Object> Users = [1,2,3,4,5,6,7,8,9,10];
  var deviceHeight, deviceWidth;

  Widget _ChatCardeView(width, height, [object]){
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
                      Text("FILOT 전체 톡방",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      Padding(padding: EdgeInsets.all(_widthRate*4)),

                      Container(
                        width: _widthRate*6,
                        height: _hegihtRate*10,
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
                      Flexible(child: Text("Latest Chat Text", overflow: TextOverflow.ellipsis,maxLines: 1,)),
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

  void _goToChatting(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Chatting(userObj: new UserData('jongs1eo'))));
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
                  Container(
                    width: double.infinity,
                    height: rateHeight*5,
                    alignment: Alignment.bottomLeft,
                    child: Icon(Icons.star,size: 40,color: Colors.yellow,),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    width: (MyProfileWidget_width=rateWidth * 100),
                    height: (MyProfileWidget_height=100.0),
                    child: Center(
                        child: GestureDetector(
                          onTap: (){_goToChatting();},
                          child: _ChatCardeView(MyProfileWidget_width,MyProfileWidget_height),
                        )
                    ),
                  ),
                ],
              ),
            ),
            height: rateHeight*20,
          ),
          Container(height: 20,width: double.infinity, child: Center(child: Container( height: 1, width: rateWidth*100, color: Colors.black87),)),
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
                        onTap: () {_goToChatting();},
                        child: Center(child: _ChatCardeView(
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
    );
  }
}
