import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FindClientInfo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FindClientInfo();
}
class _FindClientInfo extends State<FindClientInfo>{
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();
  var sum = '0';

  List _buttonList = ['plus','minus','multi','div'];
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _buttonText = '';
  String calculate = 'plus';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Find ID and Password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: <Widget>[
                  Text(
                    'Results: $sum',
                    style: TextStyle(fontSize: 20),
                  ),
                  TextField(
                    controller: value1,
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: value2,
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButton(
                    items: _dropDownMenuItems,
                    onChanged: (value){
                      setState(() {
                        _buttonText = value.toString();
                        calculate = value.toString();
                      });
                    },value: _buttonText,
                  ),
                  RaisedButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.west_sharp),
                          Text(calculate)
                        ],
                      ),
                      color: Colors.amber,
                      onPressed: () {
                        setState(() {
                          int result = cal(calculate, int.parse(value1.value.text), int.parse(value2.value.text));
                          sum = '$result';
                        });
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(var item in _buttonList){
      _dropDownMenuItems.add(DropdownMenuItem(value: item, child: Text(item)));
    }
    _buttonText = _dropDownMenuItems[0].value!;
  }

  int cal(String state, int a, int b) {
    if (state == 'plus')
      return a + b;
    else if (state == 'minus')
      return a - b;
    else if (state == 'multi')
      return a * b;
    else
      return a ~/ b;//(a / b).toInt();
  }
}