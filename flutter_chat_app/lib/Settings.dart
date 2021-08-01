import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Settings();
}
class _Settings extends State<Settings>{
  TextEditingController _textController = new TextEditingController();
  String _sendText = '';
  var _rateHeight,_rateWidth;
  @override
  Widget build(BuildContext context) {
    _rateHeight = MediaQuery.of(context).size.height / 100;
    _rateWidth = MediaQuery.of(context).size.width / 100;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        primary: true,
        actions: <Widget>[
          IconButton(onPressed: (){Navigator.of(context).pushReplacementNamed('/main');}, icon: Icon(Icons.home,size: 30,))
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
    throw UnimplementedError();
  }

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
                Navigator.of(context).pushReplacementNamed('/');
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

}