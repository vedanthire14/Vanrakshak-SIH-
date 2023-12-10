import 'package:flutter/material.dart';

class EnumerationScreen extends StatefulWidget {
  final VoidCallback onDataFulfilled;

  const EnumerationScreen({Key? key, required this.onDataFulfilled})
      : super(key: key);

  @override
  _EnumerationScreenState createState() => _EnumerationScreenState();
}

class _EnumerationScreenState extends State<EnumerationScreen> {
  String aaa = "Aaa";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              aaa = "Bbb";
            });
          },
          child: Text(aaa),
        ),
      ),
    );
  }
}
