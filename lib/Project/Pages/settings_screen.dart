import 'dart:convert';

import 'package:app/components/common/input_field/custom_input_field.dart';
import 'package:app/components/common/validator/validators.dart';
import 'package:app/models/User.dart';
import 'package:app/network_utils/api.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  String name;
  String email;
  String phone;
  String id;
  SettingsScreen(this.name, this.email, this.phone, this.id);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  double _fontSize = 7.0;
  double _ratingIndicator = 0.0;
  bool _isLoading = false;
  bool checkValue;
  SharedPreferences sharedPreferences;
  TextEditingController _textFieldController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FocusNode _nodePhone;
  FocusNode _nodeEmail;
  FocusNode _nodeFullname;
  String email = "";
  String phone = "";
  String name = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _simulateLoad();
    email = widget.email;
    name = widget.name;
    phone = widget.phone;
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;

    getCredential();
  }

  // _simulateLoad() async {
  //   widget.email = await getValue('email') ?? "";
  //   widget.name = await getValue('name') ?? "";
  // }

  getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = sharedPreferences.getDouble("font");
      // if (_ratingIndicator != null) {
      //     username.text = sharedPreferences.getString("username");
      //     password.text = sharedPreferences.getString("password");

      // } else {
      //   checkValue = false;
      // }
    });
  }

  getValue(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(name);
    print("uniteddd$stringValue");
    return stringValue;
  }

  _displayDialogName() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Profile Details'),
            content: Container(
                //     children: <Widget>[TextField(
                //   controller: _textFieldController,
                //   textInputAction: TextInputAction.go,
                //   keyboardType: TextInputType.numberWithOptions(),
                //   decoration: InputDecoration(hintText: "Edit Name"),
                // ),]),
                //your field code
                child: SingleChildScrollView(
                    // give a controller
                    controller: _scrollController,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextField(
                            focusNode: _nodeFullname,
                            maxLength: 60,
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                            textInputAction: TextInputAction.next,
                            onChanged: (String value) {
                              name = value;
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(_nodePhone);
                            },
                          ),

                          TextField(
                            focusNode: _nodePhone,
                            maxLength: 15,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone number',
                            ),
                            textInputAction: TextInputAction.next,
                            onChanged: (String value) {
                              phone = value;
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(_nodeEmail);
                            },
                          ),
                          //suppose this is your very last textfield
                          TextField(
                            focusNode: _nodeEmail,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                            textInputAction: TextInputAction.next,
                            onChanged: (String value) {
                              email = value;
                            },
                            // onEditingComplete: () {
                            //   FocusScope.of(context)
                            //       .requestFocus(_nodeFullname);
                            // },
                            onTap: () {
                              Future.delayed(Duration(milliseconds: 500), () {
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.ease);
                              });
                            },
                          ),
                        ]))),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () {
                  print(email);
                  print(phone);
                  print(name);
                  print("the id${widget.id}");
                  _editProfile(name, email, phone, widget.id);
                  // Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    // _scaffoldKey.currentState.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _editProfile(String name, String email, String phone, String id) async {
    setState(() {
      _isLoading = true;
    });
    var data = {'email': email, 'name': name, 'phone': phone, 'id': id};

    var res = await Network().authData(data, '/user');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      //final Map<String, dynamic> responseData = body;
      //body['user'].Map()
      var usermodel = new User.fromJson(body['user']);
      localStorage.setString('name', usermodel.name);
      localStorage.setString('email', usermodel.email);
      localStorage.setString('phone', usermodel.phone);

      //usermodel.uuid =
      localStorage.setString('user', json.encode(body['user']));
      _showMsg(body['msg']);
      // Navigator.push(
      //   context,
      //   new MaterialPageRoute(builder: (context) => Rout.home),
      // );
    } else {
      print("jh" + body['message']);
      _showMsg(body['msg']);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        // actions: [
        //   new IconButton(
        //       icon: new Icon(Icons.edit), onPressed: _displayDialogName())
        // ],
      ),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Account',
          tiles: [
            SettingsTile(
              title: "Name",
              leading: Icon(Icons.person),
              subtitle: widget.name ?? "Name",
              onTap: () {
                _displayDialogName();
              },
            ),
            SettingsTile(
              title: "Email",
              leading: Icon(Icons.email),
              subtitle: widget.email ?? "Email",
              onTap: () {
                _displayDialogName();
              },
            ),
            SettingsTile(
              title: "Phone",
              leading: Icon(Icons.phone),
              subtitle: widget.phone ?? "Phone",
              onTap: () {
                _displayDialogName();
              },
            ),
            // SettingsTile(
            //     title: 'Password', leading: Icon(Icons.security)),
            // SettingsTile(
            //   title: 'Bible Font',
            //   leading: Icon(Icons.edit),
            //   subtitle:
            //       _fontSize.toString() == "null" ? "12" : _fontSize.toString(),
            //   onTap: () {
            //     _showFontSizePickerDialog();
            //     //_showMyDialog();
            //     // showModalBottomSheet(
            //     //     context: context,
            //     //     builder: (BuildContext context) {
            //     //       return _generateTags();
            //     //     });
            //   },
            // ),
          ],
        ),
        // SettingsSection(
        //   title: 'Notification',
        //   tiles: [
        //     SettingsTile.switchTile(
        //       title: 'Get Email Notifications',
        //       leading: Icon(Icons.email),
        //       switchValue: lockInBackground,
        //       onToggle: (bool value) {
        //         setState(() {
        //           lockInBackground = value;
        //           notificationsEnabled = value;
        //         });
        //       },
        //     ),
        //     SettingsTile.switchTile(
        //       title: 'Enable Push Notifications',
        //       enabled: notificationsEnabled,
        //       leading: Icon(Icons.notifications_active),
        //       switchValue: true,
        //       onToggle: (value) {},
        //     ),
        //   ],
        // ),
        SettingsSection(
          title: 'Misc',
          tiles: [
            SettingsTile(
                title: 'Terms of Service', leading: Icon(Icons.description)),
          ],
        ),
        CustomSection(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22, bottom: 8),
                child: Image.asset(
                  'assets/images/settings.png',
                  height: 50,
                  width: 50,
                  color: Color(0xFF777777),
                ),
              ),
              Text(
                'Version: 1.0.0',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
