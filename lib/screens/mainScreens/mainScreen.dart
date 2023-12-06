// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vanrakshak/screens/introSlider/introSlider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyLiquidSwipe(),
            ),
          );
        },
        child: Text("Logout"),
      ),
    ));
  }
}
