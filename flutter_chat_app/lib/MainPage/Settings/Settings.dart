import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Settings();
}
class _Settings extends State<Settings>{
  /// 기기 사이즈를 받고, 비율을 지정
  var _rateHeight,_rateWidth;

  /// 로그아웃 UI를 만들어주는 위젯 메소드
  /// 실제 로그아웃을 담당하고, 초기 화면으로 이동한다.
  Widget _LogOut([str]) {
    return Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.black54,
                ),
                top: BorderSide(
                  width: 1,
                  color: Colors.black12,
                )
            )
        ),
        width: _rateWidth*100,
        height: 50,
        child: Wrap(
          children: [
            ElevatedButton(
              onPressed: (){
                // Logout function and releas token
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: Row(
                children: [
                  Icon(Icons.logout,color: Colors.black54,size: 20,),
                  Text(" Logout",style: TextStyle(color: Colors.black54, fontSize: 14),),
                ],
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                  fixedSize: MaterialStateProperty.all<Size>(Size(100, 40)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder(side: BorderSide.none) )
              ),
            ),
          ],
        ),
    );
  }

  @override  /// 실제 화면을 build하는 메소드
  Widget build(BuildContext context) {
    _rateHeight = MediaQuery.of(context).size.height / 100;
    _rateWidth = MediaQuery.of(context).size.width / 100;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        primary: true,
        actions: <Widget>[
          IconButton(onPressed: (){Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);}, icon: Icon(Icons.home,size: 30,))
        ],
        backgroundColor: Colors.grey,
        foregroundColor: Colors.blue,
      ),
      bottomNavigationBar: _LogOut(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),


    );
  }
}