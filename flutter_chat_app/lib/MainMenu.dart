import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ChatList.dart';
import 'package:flutter_chat_app/FriendsList.dart';
import 'package:flutter_chat_app/MyProfile.dart';

class MainMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> with SingleTickerProviderStateMixin{
  var rateHeight;
  late TabController controller;
  int _selectedIndex = 0;
  bool mute = false;

  @override
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

  Widget _MenuRoute(int index){
    switch(index){
      case 0:
        return MyProfile();
      case 1:
        return FriendsList();
      case 2:
        return ChatList();
      case 3:
        return ChatList();
    }
    return MyProfile();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
}