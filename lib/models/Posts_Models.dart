class Post_models {
  List<Data> _data;

  Post_models({List<Data> data}) {
    this._data = data;
  }

  List<Data> get data => _data;
  set data(List<Data> data) => _data = data;

  Post_models.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      _data = new List<Data>();
      json['data'].forEach((v) {
        _data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._data != null) {
      data['data'] = this._data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String _title;
  String _slug;
  String _image;
  String _body;
  User _user;
  String _createdAt;

  Data(
      {String title,
      String slug,
      String image,
      String body,
      User user,
      String createdAt}) {
    this._title = title;
    this._slug = slug;
    this._image = image;
    this._body = body;
    this._user = user;
    this._createdAt = createdAt;
  }

  String get title => _title;
  set title(String title) => _title = title;
  String get slug => _slug;
  set slug(String slug) => _slug = slug;
  String get image => _image;
  set image(String image) => _image = image;
  String get body => _body;
  set body(String body) => _body = body;
  User get user => _user;
  set user(User user) => _user = user;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;

  Data.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _slug = json['slug'];
    _image = json['image'];
    _body = json['body'];
    _user = json['user'] != null ? new User.fromJson(json['user']) : null;
    _createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['slug'] = this._slug;
    data['image'] = this._image;
    data['body'] = this._body;
    if (this._user != null) {
      data['user'] = this._user.toJson();
    }
    data['created_at'] = this._createdAt;
    return data;
  }
}

class User {
  String _uuid;
  String _avatar;
  String _name;
  String _email;
  String _phone;
  List<Roles> _roles;
  String _createdAt;

  User(
      {String uuid,
      String avatar,
      String name,
      String email,
      String phone,
      List<Roles> roles,
      String createdAt}) {
    this._uuid = uuid;
    this._avatar = avatar;
    this._name = name;
    this._email = email;
    this._phone = phone;
    this._roles = roles;
    this._createdAt = createdAt;
  }

  String get uuid => _uuid;
  set uuid(String uuid) => _uuid = uuid;
  String get avatar => _avatar;
  set avatar(String avatar) => _avatar = avatar;
  String get name => _name;
  set name(String name) => _name = name;
  String get email => _email;
  set email(String email) => _email = email;
  String get phone => _phone;
  set phone(String phone) => _phone = phone;
  List<Roles> get roles => _roles;
  set roles(List<Roles> roles) => _roles = roles;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;

  User.fromJson(Map<String, dynamic> json) {
    _uuid = json['uuid'];
    _avatar = json['avatar'];
    _name = json['name'];
    _email = json['email'];
    _phone = json['phone'];
    if (json['roles'] != null) {
      _roles = new List<Roles>();
      json['roles'].forEach((v) {
        _roles.add(new Roles.fromJson(v));
      });
    }
    _createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this._uuid;
    data['avatar'] = this._avatar;
    data['name'] = this._name;
    data['email'] = this._email;
    data['phone'] = this._phone;
    if (this._roles != null) {
      data['roles'] = this._roles.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this._createdAt;
    return data;
  }
}

class Roles {
  int _id;
  String _name;
  String _description;
  String _createdAt;
  String _updatedAt;
  Pivot _pivot;

  Roles(
      {int id,
      String name,
      String description,
      String createdAt,
      String updatedAt,
      Pivot pivot}) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._pivot = pivot;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get description => _description;
  set description(String description) => _description = description;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  Pivot get pivot => _pivot;
  set pivot(Pivot pivot) => _pivot = pivot;

  Roles.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['description'] = this._description;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    if (this._pivot != null) {
      data['pivot'] = this._pivot.toJson();
    }
    return data;
  }
}

class Pivot {
  int _userId;
  int _roleId;

  Pivot({int userId, int roleId}) {
    this._userId = userId;
    this._roleId = roleId;
  }

  int get userId => _userId;
  set userId(int userId) => _userId = userId;
  int get roleId => _roleId;
  set roleId(int roleId) => _roleId = roleId;

  Pivot.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this._userId;
    data['role_id'] = this._roleId;
    return data;
  }
}
