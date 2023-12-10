import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vanrakshak/resources/api/apiResponse.dart';

class EnumerationScreen extends StatefulWidget {
  final VoidCallback onDataFulfilled;
  final String projectID;

  const EnumerationScreen(
      {Key? key, required this.onDataFulfilled, required this.projectID})
      : super(key: key);

  @override
  _EnumerationScreenState createState() => _EnumerationScreenState();
}

class _EnumerationScreenState extends State<EnumerationScreen> {
  int treeCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String url =
                "http://10.0.2.2:5000/treeEnumeration?ProjectID=${widget.projectID}";
            Uri uri = Uri.parse(url);
            print(uri);
            var jsonData = await apiResponse(uri);
            var decodedData = jsonDecode(jsonData);

            setState(() {
              treeCount = decodedData['treeCount'];
            });
            print(treeCount);
          },
          child: Text(treeCount.toString()),
        ),
      ),
    );
  }
}
