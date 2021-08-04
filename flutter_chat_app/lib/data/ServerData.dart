import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class ServerData {
  static final Map<String,String> KeyList = // <My Use Key, value of api key>
  {
    'id' : 'id',
    'pwd' : 'password',
    'checkpwd' : 'confirmPassword',
    'nick' : 'nickName',
    'name' : 'name',
    'phone' : 'phoneNumber',
    'email' : 'email',
    'github' : 'github',
    'role' : 'role',
    'state' : 'state',
    'image' : 'img', // 이미지 정보 key값
    'token' : 'token',
    'msg' : 'message',
  };
  static final api = 'https://en5f3ghmodccnhn.m.pipedream.net';

}