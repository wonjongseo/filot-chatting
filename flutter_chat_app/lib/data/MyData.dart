import 'dart:convert';

import 'package:flutter_chat_app/data/ProfileData.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:http/http.dart' as http;

class MyData extends UserData{
  /** 수정 사항 **/
  final _user_data_update_api = ServerData.api + '';
  /** 수정 사항 **/


  MyData(name,[data]) : super(name,[data]);

  Future<String> UpdateData() async{
    String msg;
    try {
      final response = await http.put(
        Uri.parse(_user_data_update_api),
        body: jsonEncode(
          {
            ServerData.KeyList['name']: super.getName(),
            ServerData.KeyList['github']: super.getGithub(),
            ServerData.KeyList['email']: super.getEmail(),
            ServerData.KeyList['phone']: super.getPhone(),
            ServerData.KeyList['role']: super.getRole(),
            ServerData.KeyList['state']: super.getState(),
          },
        ),
        headers: {'Content-Type': "application/json"},
      );
      msg = jsonDecode(response.body)[ServerData.KeyList['msg']].toString();
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
    String msg = jsonDecode(response.body)[ServerData.KeyList!['msg']].toString();

    return msg;
  }
}