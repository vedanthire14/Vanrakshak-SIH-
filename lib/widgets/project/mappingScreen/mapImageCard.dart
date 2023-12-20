// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapImageCard extends StatelessWidget {
  final String imageUrl;
  final String text;
  final Color frontColor = Color.fromARGB(255, 255, 255, 255);
  final double cardWidth;
  final Color bgColor = Color.fromARGB(255, 69, 170, 173);

  MapImageCard({
    Key? key,
    required this.imageUrl,
    required this.text,
    this.cardWidth = 350,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: 380,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          color: frontColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    height: 270,
                    width: double.infinity,
                    fit: BoxFit.fill,
                     errorBuilder: (context, error, stackTrace) {
    return Text('Unable to load image');
  },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: bgColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//GOOGLE MAP INPUT  CARD CODE

class GoogleMapsCard extends StatelessWidget {
  final GoogleMap googleMap;
  final double cardWidth;
  final double mapHeight;
  final Color frontColor = const Color.fromARGB(255, 255, 255, 255);
  final Color bgColor = const Color.fromARGB(255, 69, 170, 173);

  const GoogleMapsCard({
    Key? key,
    required this.googleMap,
    this.cardWidth = 350, // Matched to MapImageCard width
    this.mapHeight = 270,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          color: frontColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    height: mapHeight, // Set the height of the GoogleMap widget
                    child: googleMap,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "INTEGRATED GOOGLE MAPS",
                    style: TextStyle(
                      color: bgColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
