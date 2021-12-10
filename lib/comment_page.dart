import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/comments_list.dart';
import 'package:flutter_application_1/custom_widgets.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/service.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

import 'wine_page.dart';

class CommentPage extends StatefulWidget {
  Wine wine;
  CommentPage({Key? key, required this.wine}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  int rate = 0;
  late CommentModel comment;
  final GlobalKey<FormState> _formComm = GlobalKey<FormState>();

  Future<ApiResponse> sendComm() async {
    ApiResponse _apiResponse = ApiResponse();
    var url = Uri.parse('http://10.0.2.2:3211/api/sendcomm');

    final Map<String, dynamic> bodyData = {
      'id': widget.wine.id,
      'ident': comment.user,
      'commentaire': comment.comment,
      'note': comment.note
    };
    var response = await http.post(url, body: jsonEncode(bodyData), headers: {
      "accept": "application/json",
      "content-type": "application/json"
    });
    switch (response.statusCode) {
      case 200:
        var result = json.decode(response.body);
        _apiResponse.Data = result;
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
            key: _formComm,
            child: Column(
              children: <Widget>[
                TextFormField(
                  onSaved: (newValue) {
                    comment = CommentModel(
                        user: Service().user,
                        comment: newValue ?? "",
                        note: rate);
                  },
                  decoration:
                      const InputDecoration(hintText: "Votre commentaire"),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return ('Vous ne pouvez poster un commentaire vide.');
                    }
                    return null;
                  },
                ),
                SmoothStarRating(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: 1,
                  size: 40,
                  onRated: (v) {
                    rate = v.round();
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formComm.currentState!.validate()) {
                        _formComm.currentState!.save();
                        var tmp = await sendComm();
                        if (tmp.Data != null) print('object');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return WinePage(request: tmp.Data);
                        }));
                      }
                    },
                    child: const Text("Commenter"))
              ],
            )),
      ),
    );
  }
}
