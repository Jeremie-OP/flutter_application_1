import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/wine_page.dart';
import 'package:http/http.dart' as http;

import 'custom_widgets.dart';
import 'service.dart';

class AddWineScreen extends StatefulWidget {
  AddWineScreen({Key? key}) : super(key: key);

  @override
  _AddWineScreenState createState() => _AddWineScreenState();
}

class _AddWineScreenState extends State<AddWineScreen> {
  final GlobalKey<FormState> _formWine = GlobalKey<FormState>();
  String? wineName;
  String? wineDomain;
  String? wineYear;

  Future<ApiResponse> addWine() async {
    var _apiResponse = ApiResponse();
    var url = Uri.parse('http://10.0.2.2:3211/api/addwine');
    var token = Service().token;
    var response = await http.post(url, body: {
      'wineName': wineName,
      'wineDomain': wineDomain,
      'wineYear': wineYear,
      'jwt': token
    });
    switch (response.statusCode) {
      case 200:
        var result = json.decode(response.body);
        _apiResponse.Data = result;
        break;
      case 400:
        _apiResponse.Data = 400;
        break;
      default:
        break;
    }
    return _apiResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWine(),
      drawer: DrawerWine(),
      body: Container(
        child: Form(
          key: _formWine,
          child: Column(
            children: <Widget>[
              Container(),
              TextFormField(
                onSaved: (newValue) => wineName = newValue,
                decoration: const InputDecoration(
                  hintText: "Entrez le nom du vin",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return ('Veuillez entrer le nom du vin');
                  }
                  return null;
                },
              ),
              TextFormField(
                onSaved: (newValue) => wineDomain = newValue,
                decoration: const InputDecoration(
                  hintText: "Entrez le nom du domaine du vin",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return ('Veuillez entrer le nom du doamine du vin');
                  }
                  return null;
                },
              ),
              TextFormField(
                onSaved: (newValue) => wineYear = newValue,
                decoration: const InputDecoration(
                  hintText: "Entrez l'annee du vin",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return ("Veuillez entrer l'annee du vin");
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formWine.currentState!.validate()) {
                      _formWine.currentState!.save();
                      var tmp = await addWine();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return WinePage(request: tmp.Data);
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
