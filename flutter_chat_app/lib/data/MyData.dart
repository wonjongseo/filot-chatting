import 'dart:convert';

import 'package:flutter_chat_app/data/ProfileData.dart';
import 'package:http/http.dart' as http;

class MyData extends UserData{
  /** 수정 사항 **/
  final _user_data_update_api = 'https://en5f3ghmodccnhn.m.pipedream.net';
  Map<String,String> _KeyList = // <My Use Key, value of api key>
  {
    'name' : 'name',
    'phone' : 'phoneNumber',
    'email' : 'nickName',
    'github' : 'github',
    'role' : 'role',
    'state' : 'state',
    'msg' : 'message'
  };
  /** 수정 사항 **/


  MyData(name) : super(name);

  Future<String> UpdateData() async{
    String msg;
    try {
      final response = await http.put(
        Uri.parse(_user_data_update_api),
        body: jsonEncode(
          {
            _KeyList['name']: super.getName(),
            _KeyList['github']: super.getGithub(),
            _KeyList['email']: super.getEmail(),
            _KeyList['phone']: super.getPhone(),
            _KeyList['role']: super.getRole(),
            _KeyList['state']: super.getState(),
          },
        ),
        headers: {'Content-Type': "application/json"},
      );
      msg = jsonDecode(response.body)[_KeyList['msg']].toString();
    }
    catch (e) {
      msg = e.toString();
    }
    return msg;
  }
  Future<String> UpdatePrivateData() async{
    /** 비밀번호 또는 민감한 정보 변경 **/
    final response = await http.put(
      Uri.parse(_user_data_update_api),
      body: jsonEncode(
        {
        },
      ),
      headers: {'Content-Type': "application/json"},
    );
    String msg = jsonDecode(response.body)[_KeyList!['msg']].toString();

    return msg;
  }
}