import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'custom_widgets.dart';
import 'take_picture_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  var token;

  HomePage({Key? key, this.token}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var firstCamera;
  String user = "";

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  Future<String?> get jwtOrEmpty async {
    String? jwt = await FlutterSecureStorage().read(key: "jwt");
    if (jwt == null) return null;
    return jwt;
  }

  Future<String> initToken() async {
    String? tmpData;
    tmpData = await FlutterSecureStorage().read(key: "jwt");
    if (widget.token != null) {
      var tmp = JwtDecoder.decode(widget.token);
      user = tmp["ident"];
      if (tmpData == null || tmpData != widget.token) {
        await FlutterSecureStorage().write(key: "jwt", value: widget.token);
      }
    } else if (tmpData != null /*&& JwtDecoder.isExpired(tmpData)*/) {
      //la verification de l'expiration semble non fonctionnel
      var tmp = JwtDecoder.decode(tmpData);
      user = tmp["ident"];
    } else {
      user = "inconnu";
    }
    return user;
  }

  Future<void> customInit() async {
    await initCamera();
  }

  @override
  void initState() {
    customInit().then((value) => super.initState());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Wine Note',
      home: Scaffold(
        drawer: DrawerWine(),
        appBar: AppBarWine(),
        body: Center(
          child: Column(children: <Widget>[
            FutureBuilder<String>(
                future: initToken(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData)
                    return Text(user);
                  else
                    return CircularProgressIndicator();
                }),
            const Image(
                image: NetworkImage(
                    "https://media0.giphy.com/media/cfuL5gqFDreXxkWQ4o/giphy.gif")),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TakePictureScreen(
                          camera: firstCamera,
                        )));
          },
          child: const Icon(Icons.camera),
          backgroundColor: Colors.pink,
        ),
      ),
    );
  }
}
