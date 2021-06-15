import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/components/common/button/form_button.dart';
import 'package:app/components/common/input_field/custom_input_field.dart';
import 'package:app/components/common/separator/separator.dart';
import 'package:app/components/common/style/styles.dart';
import 'package:app/components/common/validator/validators.dart';
import 'package:app/models/User.dart';
import 'package:app/network_utils/api.dart';
import 'package:app/routers/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final String welcomeText;

  Login({this.welcomeText});

  @override
  LoginState createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  /// Title and Welcome text are defined under
//  final String title = "LOGIN";
//  final String welcomeText = 'Hello there, \nwelcome back.';

  //  _formKey and _autoValidate
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _username;
  String _password;
  bool _isLoading = false;
  User userData = User();
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(this.widget.welcomeText,
                  style: TextStyle(
                      color: Styles.helperTextColor,
                      fontSize: Styles.h1,
                      fontWeight: Styles.lightFont)),
            ),
            Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[
                  /// USERNAME INPUT
                  /// ===============
                  CustomInputField(
                    hintText: 'Email',
                    validator: Validators.validateEmail,
                    onSaved: (String val) {
                      email = val;
                      print(email);
                    },
                    inputType: TextInputType.emailAddress,
                    margin: EdgeInsets.only(top: 28.0),
                  ),

                  /// PASSWORD INPUT
                  /// ===============
                  CustomInputField(
                    obscureText: true,
                    hintText: 'Password',
                    validator: Validators.generalValidate,
                    onSaved: (String val) {
                      password = val;
                      print(password);
                    },
                    inputType: null,
                    margin: EdgeInsets.only(top: 28.0),
                  ),
                  Separator(height: 50.0),

                  /// SIGN IN BUTTON
                  FormButton(
                    text: "SIGN IN",
                    onTap: _validateInputs,
                  ),
                  Separator(height: 20.0),
                  Center(
                      child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("FORGOT PASSWORD? ",
                              style: TextStyle(
                                  color: Styles.helperTextColor,
                                  fontSize: Styles.h5,
                                  fontWeight: Styles.lightFont)),
                          InkWell(
                            child: Container(
                                height: 40.0,
                                child: Center(
                                  child: Text("GET NEW!",
                                      style: TextStyle(
                                          color: Styles.helperTextColor,
                                          fontWeight: Styles.mediumFont,
                                          fontSize: Styles.h5)),
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Rout.forgotPassword),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("DON'T HAVE AN ACCOUNT? ",
                              style: TextStyle(
                                  color: Styles.helperTextColor,
                                  fontSize: Styles.h5,
                                  fontWeight: Styles.lightFont)),
                          InkWell(
                            child: Container(
                                height: 40.0,
                                child: Center(
                                  child: Text("SIGN UP!",
                                      style: TextStyle(
                                          color: Styles.helperTextColor,
                                          fontWeight: Styles.mediumFont,
                                          fontSize: Styles.h5)),
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Rout.register),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _login();
      // _formKey.currentState.save();
      // Navigator.push(
      //   context, MaterialPageRoute(builder: (context) => Rout.home));
    } else {
      print("object");
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {'email': email, 'password': password};

    var res = await Network().authData(data, '/login');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      //final Map<String, dynamic> responseData = body;
      //body['user'].Map()
      var usermodel = new User.fromJson(body['user']);
      localStorage.setString('id', usermodel.id.toString());
      localStorage.setString('user_id', usermodel.uuid);
      localStorage.setString('name', usermodel.name);
      localStorage.setString('email', usermodel.email);
      localStorage.setString('phone', usermodel.phone);
      localStorage.setString('passowrd', password);
      //print("the IDs: ${usermodel.uuid}");

      // body['user'].Map<dynamic>((userDetail) {
      //   User usermodel = new User(
      //       uuid: userDetail['uuid'],
      //       avatar: userDetail['avatar'],
      //       name: userDetail['name'],
      //       email: userDetail['email'],
      //       phone: userDetail['phone'],
      //       createdAt: userDetail['createdAt']);
      //   // userData = usermodel;
      //   localStorage.setString('user_id', usermodel.uuid);
      //   print("the IDs: ${usermodel.uuid}");
      // });

      //usermodel.uuid =
      localStorage.setString('user', json.encode(body['user']));

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Rout.home),
      );
    } else {
      print("jh" + body['message']);
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
