import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Damnn extends StatefulWidget {
  @override
  _DamnnState createState() => _DamnnState();
}

class _DamnnState extends State<Damnn> {
  String _address = '';

  Future<void> getAddressFromCoordinates(double latitude, double longitude) async {
    final String apiKey = 'AIzaSyC5QkMgaiQo3G7RH95BWJoqzWbKczWVCkU';
    final String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['results'] != null && jsonResponse['results'].length > 0) {
        setState(() {
          _address = jsonResponse['results'][0]['formatted_address'];
        });
      }
    } else {
      print('Failed to get address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address Lookup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => getAddressFromCoordinates(23.669147263579056, 85.31555883586407),
              child: Text('Get Address'),
            ),
            SizedBox(height: 20),
            Text(_address),
          ],
        ),
      ),
    );
  }
}
