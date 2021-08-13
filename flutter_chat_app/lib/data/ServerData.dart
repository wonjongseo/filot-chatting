import 'package:flutter_chat_app/data/MyData.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
late MyData myData;// = new MyData('jh');

class ServerData {
  static bool JHtest = true;
  static final Map<String,String> ApiList = /// <My Use Key, value of api key>
  {
    '/chat' : (JHtest ? '/chat' : '/chat'),
    '/login' : (JHtest ? '' : '/login'),
    '/join': (JHtest ? '' : '/join'),
    '/check': (JHtest ? '' : '/check'),
    '/find': (JHtest ? '' : '/find'),
    '/friends': (JHtest ? '' : '/friends'),
    '/myprofile' : (JHtest ? '' : '/myprofile'),
    '/userupdate' : (JHtest ? '' : '/update'),
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
    'enter-room' : 'enter-room',
    'load-message' : 'load-message',
  };
  static final api = (JHtest ? 'https://en5f3ghmodccnhn.m.pipedream.net' : '형의 api 메인 주소');
}