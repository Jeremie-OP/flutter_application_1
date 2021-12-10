import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_vin.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/register.dart';
import 'package:flutter_application_1/service.dart';
import 'package:flutter_application_1/wine_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login.dart';

class AppBarWine extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      title: const Text('Wine Note'),
      actions: [Icon(Icons.wine_bar)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40.0);
}

class DrawerWine extends StatefulWidget {
  DrawerWine({Key? key}) : super(key: key);

  @override
  _DrawerWineState createState() => _DrawerWineState();
}

class _DrawerWineState extends State<DrawerWine> {
  bool connected = false;

  @override
  void initState() {
    var service = Service();
    var tmp = service.user;
    connected = Service().user != "inconnu" ? true : false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text("Wine Note")),
          ListTile(
            title: const Text('Home'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()))
            },
          ),
          Visibility(
              visible: !connected,
              child: ListTile(
                title: const Text('Se connecter'),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()))
                },
              )),
          Visibility(
              visible: !connected,
              child: ListTile(
                title: const Text("S'enregistrer"),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()))
                },
              )),
          Visibility(
              visible: connected,
              child: ListTile(
                title: const Text('Logout'),
                onTap: () {
                  setState(() {});
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Disconnect()));
                },
              )),
          Visibility(
              visible: Service().admin,
              child: ListTile(
                title: const Text('Ajouter un vin'),
                onTap: () {
                  setState(() {});
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddWineScreen()));
                },
              )),
        ],
      ),
    );
  }
}

class Disconnect extends StatelessWidget {
  Future<int> disconnectSession(BuildContext context) async {
    await FlutterSecureStorage().delete(key: "jwt");
    Service().reset();
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: FutureBuilder<int>(
        future: disconnectSession(context),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
