// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vanrakshak/screens/authScreens/loginScreen.dart';

class MyAppDrawer extends StatelessWidget {
  const MyAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 69, 170, 173),
            ),
            child: Text(
              'Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
          ListTile(
            title: Text('Mapping'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Enumeration'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Species'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Reports'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Projects'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              });
            },
          ),
        ],
      ),
    );
  }
}
