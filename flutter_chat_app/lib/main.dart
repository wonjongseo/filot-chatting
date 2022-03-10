import 'package:flutter/material.dart';
import 'package:flutter_chat_app/LoginPage/LoginPage.dart';
import 'package:flutter_chat_app/MainPage/MainMenu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/main': (context) => MainMenu(),
      },
    );
  }
}