import 'package:flutter/material.dart';

class EnumerationScreen extends StatefulWidget {
  final VoidCallback onDataFulfilled;

  const EnumerationScreen({Key? key, required this.onDataFulfilled}) : super(key: key);

  @override
  _EnumerationScreenState createState() => _EnumerationScreenState();
}

class _EnumerationScreenState extends State<EnumerationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Settings'),
      ),
    );
  }
}
