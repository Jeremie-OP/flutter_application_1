import 'package:flutter/material.dart';
import 'package:flutter_application_1/comments_list.dart';
import 'package:flutter_application_1/custom_widgets.dart';

class Wine {
  late String id;
  late String name;
  late String domain;
  late String year;
  late List<CommentModel> comments;

  Wine();

  Wine.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['nom'];
    domain = json['domaine'];
    year = json['annee'];
    if (json['commentaires'] != null) {
      comments = <CommentModel>[];
      json['commentaires'].forEach((v) {
        comments.add(CommentModel(
            user: v['ident'], comment: v['commentaire'], note: v['note']));
      });
    }
  }
}

class WinePage extends StatefulWidget {
  var request;

  WinePage({Key? key, this.request}) : super(key: key);

  @override
  _WinePageState createState() => _WinePageState();
}

class _WinePageState extends State<WinePage> {
  late Wine wine;

  @override
  void initState() {
    // TODO: implement initState
    wine = Wine.fromJson(widget.request);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWine(),
      appBar: AppBarWine(),
      body: Container(
          color: Colors.deepPurple,
          child: Column(children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                wine.name,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              constraints: BoxConstraints.expand(),
              decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Domaine
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    wine.domain,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Le fameux domaine"),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  // Annee
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    wine.year,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 5),
                    child: Text("L'annee du merdier"),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  )
                ],
              ),
            )),
          ])),
    );
  }
}
