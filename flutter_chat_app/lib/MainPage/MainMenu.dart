import 'package:flutter/material.dart';
import 'package:flutter_chat_app/MainPage/Chatting/ChatList.dart';
import 'package:flutter_chat_app/MainPage/Friends/FriendsList.dart';
import 'package:flutter_chat_app/MainPage/Mores/MorePage.dart';
import 'package:flutter_chat_app/MainPage/MyProfile/MyProfile.dart';
import 'package:flutter_chat_app/MainPage/Settings/Settings.dart';

/// 이 컨텍스트는 왼쪽 메뉴 바를 표현한다.
class MainMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> with SingleTickerProviderStateMixin{

  /// 메뉴 바를 설정하기 위한 기기의 세로 사이즈 비율 저장 변수
  var rateHeight;
  /// 각 탭에 따른 컨텍스트 라우터를 위한 controller
  late TabController controller;
  /// 각 탭에 따른 인덱스 저장 변수
  int _selectedIndex = 0;
  /// 소리 제어에 대한 변수 true: sound on / false: sound off
  bool mute = true;

  /// Index를 받아 해당하는 context를 오른쪽 화면에 띄운다.
  /// base는 My Profile context이다.
  Widget _MenuRoute(int index){
    switch(index){
      case 0:
        return MyProfile();
      case 1:
        return FriendsList();
      case 2:
        return ChatList();
      case 3:
        return Mores();
    }
    return MyProfile();
  }

  @override /// 초기화 메서드, 탭에 대한 controller를 설정한다.
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }
  @override /// 소멸자 메서드
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override /// 실제 화면을 build하는 메소드
  Widget build(BuildContext context) {
    rateHeight = (MediaQuery.of(context).size.height / 100);
    // TODO: implement build
    return Scaffold(
        body: Row(
            mainAxisSize: MainAxisSize.values.last,
            children: <Widget>[
              NavigationRail(
                trailing: Column(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(0, rateHeight*45, 0, 0)),
                    IconButton(
                        icon: Icon((mute ? Icons.volume_up:Icons.volume_off)),
                        onPressed: () {
                          setState(() {
                            mute = !mute;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          setState(() {
                            // go to settings
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settings(),));
                          });
                        })
                  ],
                ),
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index){
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.selected,
                destinations: <NavigationRailDestination>[
                  NavigationRailDestination(icon: Icon(Icons.person), label: Text("My Profile",style: TextStyle(fontSize: 12),)),
                  NavigationRailDestination(icon: Icon(Icons.people), label: Text("Friends",style: TextStyle(fontSize: 12),)),
                  NavigationRailDestination(icon: Icon(Icons.chat_bubble), label: Text("Chat",style: TextStyle(fontSize: 12),)),
                  NavigationRailDestination(icon: Icon(Icons.more_horiz), label: Text("More",style: TextStyle(fontSize: 12),)),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: _MenuRoute(_selectedIndex))
            ]
        )
    );
  }

}