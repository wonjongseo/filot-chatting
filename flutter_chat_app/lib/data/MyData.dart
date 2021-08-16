import 'dart:convert';

import 'package:flutter_chat_app/data/ProfileData.dart';
import 'package:flutter_chat_app/data/ServerData.dart';
import 'package:http/http.dart' as http;

class MyData extends UserData {
  /** 수정 사항 **/
  final _user_data_update_api =
      ServerData.api + (ServerData.ApiList['/myprofile'] as String);
  /** 수정 사항 **/

  MyData(data) : super(data);

  /// 갱신된 데이터를 서버에 전달하는 myData만의 유일한 메서드 --server
  Future<String> UpdateData() async {
    var _tokenValue = (await storage.read(key: 'token'))!;
    print(_tokenValue);
    String msg;
    try {
      final response = await http.post(
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
        headers: {
          'Content-Type': "application/json",
          ServerData.KeyList['token'] as String: _tokenValue
        },
      );
      msg = jsonDecode(response.body)[ServerData.KeyList['msg']].toString();
    } catch (e) {
      msg = e.toString();
    }
    return msg;
  }

  /// 임시 메소드(id, pwd) 변경 메소드 --server
  Future<String> UpdatePrivateData() async {
    /** 비밀번호 또는 민감한 정보 변경 **/
    final response = await http.put(
      Uri.parse(_user_data_update_api),
      body: jsonEncode(
        {},
      ),
      headers: {'Content-Type': "application/json"},
    );
    String msg =
        jsonDecode(response.body)[ServerData.KeyList!['msg']].toString();

    return msg;
  }
}
