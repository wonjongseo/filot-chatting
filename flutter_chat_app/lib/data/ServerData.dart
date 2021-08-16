import 'dart:convert';

import 'package:flutter_chat_app/data/MyData.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

MyData myData = new MyData(ServerData.adminItem);
/** To server.
 * 관리자 및 테스트용 계정 id: admin, pwd: admin 을 생성해 두었습니다.
 * 로그인 시 admin, admin으로 하면 강제로 로그인을 합니다.
 **/



class ServerData {
  static bool JHtest = true;
  static final Map<String,String> ApiList = /// <My Use Key, value of api key>
  {
    '/chat' : (JHtest ? '' : '/chat'),
    '/rooms' : (JHtest ? '' : '/chat/rooms'),
    '/login' : (JHtest ? '' : '/users/login'),
    '/join': (JHtest ? '' : '/users/join'),
    '/check': (JHtest ? '' : '/check'),
    '/find': (JHtest ? '' : '/find'),
    '/friends': (JHtest ? '' : '/users/friends'),
    '/myprofile' : (JHtest ? '' : '/users/myprofile'),
    '/userupdate' : (JHtest ? '' : '/update'),
    '/state' : (JHtest ? '/state' : '/state'),
    '/logout' : (JHtest ? '/logout' : '/logout'),
  };
  static final Map<String,String> KeyList = /// <My Use Key, value of api key>
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
    'user' : 'user',
    'room' : 'roomNum',
    'chat' : 'chats',
    'enter-room' : 'enter-room',
    'load-message' : 'load-message',
  };
  static final api = (JHtest ? 'https://localhost:3000' : '형의 api 메인 주소');

  /// test용 json 객체
  static var adminItem = jsonEncode({
    ServerData.KeyList['name'] : "admin",
    ServerData.KeyList['role'] : "admin",
    ServerData.KeyList['phone'] : "00011112222",
    ServerData.KeyList['email'] : "admin@gmail.com",
    ServerData.KeyList['github'] : "github.com",
    ServerData.KeyList['state'] : 0,
  });
}