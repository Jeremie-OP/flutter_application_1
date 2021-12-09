import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
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

class DrawerWine extends StatelessWidget {
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
          ListTile(
            title: const Text('Se connecter'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()))
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Disconnect()))
            },
          ),
          ListTile(
            title: const Text('Vin'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => WinePage()))
            },
          )
        ],
      ),
    );
  }
}

class Disconnect extends StatelessWidget {
  Future<int> disconnectSession(BuildContext context) async {
    await FlutterSecureStorage().delete(key: "jwt");
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