import 'package:flutter_chat_app/data/MyData.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
late MyData myData = new MyData('jonsasdasdg');

class ServerData {
  static bool JHtest = false;
  static final Map<String,String> ApiList = // <My Use Key, value of api key>
  {
    '/chat' : (JHtest ? '/chat' : '/chat'),
    '/login' : (JHtest ? '' : '/login'),
    '/join': (JHtest ? '' : '/join'),
    '/check': (JHtest ? '' : '/check'),
    '/find': (JHtest ? '' : '/find'),
    '/friends': (JHtest ? '' : '/friends'),
    '/myprofile' : (JHtest ? '' : '/users/myprofile'),
    '/userupdate' : (JHtest ? '' : '/update'),
  };
  static final Map<String,String> KeyList = // <My Use Key, value of api key>
  {
    'id' : 'username',
    'pwd' : 'password',
    'checkpwd' : 'confirmpassword',
    'nick' : 'nick_name',
    'name' : 'name',
    'phone' : 'phone_number',
    'email' : 'email',
    'github' : 'github',
    'role' : 'role',
    'state' : 'state',
    'image' : 'img', // 이미지 정보 key값
    'token' : 'token',
    'msg' : 'message',
    'user' : 'user',
  };
  static final api = (JHtest ? 'https://en5f3ghmodccnhn.m.pipedream.net' : 'http://localhost:3002');
}