import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_application_1/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'custom_widgets.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class ApiResponse {
  // _data will hold any response converted into
  // its own object. For example user.
  Object? _data;
  // _apiError will hold the error object
  Object? _apiError;

  Object get Data => _data ?? '';
  set Data(Object data) => _data = data;

  Object get ApiError => _apiError as Object;
  set ApiError(Object error) => _apiError = error;
}

class ApiError {
  String? _error;

  ApiError({required String error}) {
    this._error = error;
  }

  String get error => _error ?? "";
  set error(String error) => _error = error;

  ApiError.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    return data;
  }
}

class LoginUser {
  String? id;
  var password;
  var _token;

  LoginUser();

  LoginUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'password': password.toString(),
      };

  Future<ApiResponse> authenticateUser() async {
    ApiResponse _apiResponse = new ApiResponse();
    var url = Uri.parse('http://10.0.2.2:3211/login');
    var response = await http.post(url, body: {
      'ident': id,
      'passwd': password.toString(),
    });
    switch (response.statusCode) {
      case 200:
        var jwt = response.body;
        _token = jwt;
        FlutterSecureStorage().write(key: "jwt", value: jwt);
        _apiResponse._data = _token;
        break;
      case 401:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
      default:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
    return _apiResponse;
  }
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formLogin = GlobalKey<FormState>();
  final _loginResult = LoginUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWine(),
      drawer: DrawerWine(),
      body: Container(
        child: Form(
          key: _formLogin,
          child: Column(
            children: <Widget>[
              Container(),
              TextFormField(
                onSaved: (newValue) => _loginResult.id = newValue,
                decoration: const InputDecoration(
                  hintText: "Entre votre mail",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return ('Veuillez entrer votre mail');
                  }
                  return null;
                },
              ),
              TextFormField(
                onSaved: (newValue) {
                  var bytes = utf8.encode(newValue ?? '');
                  _loginResult.password = sha256.convert(bytes);
                },
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Entre votre mot de passe",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return ('Veuillez entrer votre mot de passe');
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formLogin.currentState!.validate()) {
                      _formLogin.currentState!.save();
                      var tmp = await _loginResult.authenticateUser();
                      print("bah non 2");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HomePage(token: tmp._data);
                      }));
                    }
                  },
                  child: const Text("login"))
            ],
          ),
        ),
      ),
    );
  }
}
