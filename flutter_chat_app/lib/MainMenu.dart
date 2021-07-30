import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ChatList.dart';
import 'package:flutter_chat_app/MyProfile.dart';

class MainMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> with SingleTickerProviderStateMixin{
  late TabController controller;
  int _selectedIndex = 0;
  bool mute = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index){
              setState(() {
                if(index == 4)
                  mute = !mute;
                else
                  _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(icon: Icon(Icons.looks_one), label: Text("My Profile")),
              NavigationRailDestination(icon: Icon(Icons.looks_two), label: Text("Friends")),
              NavigationRailDestination(icon: Icon(Icons.looks_3), label: Text("Chat")),
              NavigationRailDestination(icon: Icon(Icons.looks_4), label: Text("More")),
              NavigationRailDestination(icon: Icon(Icons.looks_5), label: Text("Sound")),
              NavigationRailDestination(icon: Icon(Icons.looks_6), label: Text("Settings")),
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