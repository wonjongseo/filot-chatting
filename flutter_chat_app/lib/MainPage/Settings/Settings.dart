import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Settings();
}
class _Settings extends State<Settings>{

  /*------------------ 변수 선언 구문 ------------------*/
  /// Friends List를 불러오는 api / state를 실시간 변경됨을 소통하는 api --server
  final _Logout_api = ServerData.api + (ServerData.ApiList['/logout'] as String);
  /// 기기 사이즈를 받고, 비율을 지정
  var _rateHeight,_rateWidth;
  /*--------------------------------------------------*/

  /*------------------ 위젯 생성 메서드 구문 ------------------*/
  /// 로그아웃 UI를 만들어주는 위젯 메소드
  /// 로그아웃을 담당하고, 초기 화면으로 이동한다.
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
                // Logout function and release token
                _logout();
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
  /*--------------------------------------------------*/

  /*------------------ 데이터 처리 메서드 구문 ------------------*/
  // 아래 모든 데이터 메소드는 서버 관련 메소드 --server
  /// 실제 로그아웃 메소드, 토큰삭제 실패 시 토큰 유지, 성공 시 모든 데이터를 삭제한다.
  void _logout() async {
    var _tokenValue;
    try {
      _tokenValue = (await storage.read(key: 'token'))!;
    }catch (e){
      print(e.toString());
    }
    var response = await http.post(
      Uri.parse(_Logout_api),
      body: {
        ServerData.KeyList['token'] : _tokenValue,
      }
    );
    if(response.statusCode < 200 || response.statusCode >= 300){
      return;
    }
    storage.deleteAll();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
  /*--------------------------------------------------*/
}