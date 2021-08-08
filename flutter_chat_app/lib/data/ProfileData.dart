class UserData {
  String _name = '';
  String _phone = '';
  String _email = '';
  String _github = '';
  String _role = '';
  String _uuid = ''; //고유 식별번호
  String _imgPath = 'image/teamIcon.png';

  var _state;
  var _userObj;


  UserData(name,[userObj]){
    this._name = name;
    if(userObj != null)
      this._userObj = userObj;
  }

  String get uuid => _uuid;
  set uuid(String value) {
    _uuid = value;
  }
  set userObj(value) {
    _userObj = value;
  }
  get userObj => _userObj;
  String getName() => _name;
  void setName(String name) => this._name = name;
  String getPhone() => _phone;
  void setPhone(String? phone) => this._phone = phone!;
  String getEmail() => _email;
  void setEmail(String? email) => this._email = email!;
  String getGithub()=> _github;
  void setGithub(String? github) => this._github = github!;
  String getRole() => _role;
  void setRole(String? role) => this._role = role!;
  dynamic getState() => _state;
  void setState(String state) => this._state = state!;
  String getImage() => _imgPath;
  void setImage(String? imgPath) => this._imgPath = (imgPath!.isEmpty ? 'image/teamIcon.png' : imgPath)!;
}