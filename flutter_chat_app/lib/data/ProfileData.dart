class UserData {
  String _name = '';
  String _phone = '';
  String _email = '';
  String _github = '';
  String _role = '';
  String _imgPath = '';
  var _state;

  UserData(name){
    this._name = name;
  }
  String getName() => _name;
  void setName(String name) => this._name = name;
  String getPhone() => _phone;
  void setPhone(String phone) => this._phone = phone;
  String getEmail() => _email;
  void setEmail(String email) => this._email = email;
  String getGithub()=> _github;
  void setGithub(String github) => this._github = github;
  String getRole() => _role;
  void setRole(String role) => this._role = role;
  dynamic getState() => _state;
  void setState(state) => this._state = state;
  String getImage() => _imgPath;
  void setImage(String imgPath) => this._imgPath = (imgPath.isEmpty ? 'image/teamIcon.png' : imgPath);

/*Future<String> GetData() async{
    String msg;
    try {
      final response = await http.get(
        Uri.parse(_user_data_update_api),

        headers: {'Content-Type': "application/json"},
      );
      msg = jsonDecode(response.body)[_KeyList['msg']].toString();

      body: jsonEncode(
        {
          _KeyList['name']: getName(),
          _KeyList['github']: getGithub(),
          _KeyList['email']: getEmail(),
          _KeyList['phone']: getPhone(),
          _KeyList['role']: getRole(),
          _KeyList['state']: getState(),
        },
      );
    }
    catch (e) {
      msg = e.toString();
    }
    return msg;
  }*/
}