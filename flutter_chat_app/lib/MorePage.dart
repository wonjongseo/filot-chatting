import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

String icon_path = 'image/teamIcon.png';
String github_outline_path = 'image/github_outline.png';
String github_path = 'image/github.png';
String role_path = 'image/role.jpg';
String state_path = 'image/state.png';


class Mores extends StatelessWidget {

  Map<String,Widget> _IconList = {
    "State":FittedBox(child: Image.asset(state_path, fit: BoxFit.fitWidth,),fit: BoxFit.fill,),
    "Role":FittedBox(child: Image.asset(role_path,fit: BoxFit.fitWidth),fit: BoxFit.fill,),
    "Github":FittedBox(child: Image.asset(github_path,fit: BoxFit.fitWidth),fit: BoxFit.fill,),
    "Email":Icon(Icons.mail,color: Colors.black,),
    "Phone":Icon(Icons.smartphone,color: Colors.black,),
  };

  var deviceHeight, deviceWidth;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget> [
            Text("More",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 4
              ),
            ),
            /** 더보기 List에서 모두 끌어와요 **/
            Divider(color: Colors.black87),
            _MakeIconTap(),
          ],
        ),
    );
  }
  Widget _MakeIconTap(){
    return Flexible(
        child: GridView.count(
            crossAxisCount: deviceWidth > 500 ? 4 : 3,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              for(var item in _IconList.entries)
                Container(
                  height: 20,
                  child: GestureDetector(
                    child: Center(child: Column(
                      children: [
                        Container(child: item.value, width: 40,),
                        Text(item.key),
                      ],
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),),
                    onTap: (){print("tap");},
                  ),
                )
            ]
        )
    );
  }
}