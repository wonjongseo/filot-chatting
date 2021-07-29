import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ChatList.dart';
import 'package:flutter_chat_app/MyProfile.dart';

class MainMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> with SingleTickerProviderStateMixin{
  late TabController controller;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    /*return Scaffold(
      body: NavigationRail(
        destinations: [],
        selectedIndex: ,
        children: <Widget>[
          MyProfile(),
          ChatList(),
        ],
        controller: controller,
      ),
      bottomNavigationBar: TabBar(
        tabs: <Tab>[
          Tab(icon: Icon(Icons.looks_one, color: Colors.blue,),),
          Tab(icon: Icon(Icons.looks_two, color: Colors.blue,),)
        ],
        controller: controller,
        indicatorColor: Colors.red,
      ),
    );*/
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          MyProfile(),
          ChatList(),
        ],
        controller: controller,
      ),
      bottomNavigationBar: TabBar(
        tabs: <Tab>[
          Tab(icon: Icon(Icons.looks_one, color: Colors.blue,),),
          Tab(icon: Icon(Icons.looks_two, color: Colors.blue,),)
        ],
        controller: controller,
        indicatorColor: Colors.red,
      ),
    );
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