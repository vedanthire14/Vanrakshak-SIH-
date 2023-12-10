// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vanrakshak/screens/projectScreens/satelliteMapping.dart';

class MapScreenData extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<LatLng> points = [];
  Set<Polygon> polygon = HashSet<Polygon>();
  bool loading = false;

  SingleChildScrollView mapPage(
    Map<String, dynamic>? snapshot,
    BuildContext context,
    String projectID,
  ) {
    final screenSize = MediaQuery.of(context).size;
    if (snapshot!["isMapped"]) {
      points.clear();
      for (int i = 0; i < snapshot["map"]["coordinatesList"].length ~/ 2; i++) {
        points.add(LatLng(snapshot["map"]["coordinatesList"][i * 2],
            snapshot["map"]["coordinatesList"][i * 2 + 1]));
      }
      // print(points);

      polygon.add(
        Polygon(
          polygonId: PolygonId('1'),
          points: points,
          fillColor: Color.fromARGB(0, 37, 45, 203).withOpacity(0),
          strokeColor: Color.fromARGB(255, 37, 45, 203),
          geodesic: true,
          strokeWidth: 4,
        ),
      );

      return SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Satellite Image With Polygon",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Image.network(
              snapshot["map"]["satelliteImageWithPolygonUnmasked"],
              height: 300,
            ),
            SizedBox(height: 40),
            // Text("Polygon Area Masked Out"),
            // SizedBox(height: 20),
            // // Image.network(
            //   snapshot.data!["map"]["satelliteImageWithPolygonMasked"],
            //   height: 300,
            // ),
            Text(
              "Integrated Google Maps",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 300,
              width: 300,
              child: GoogleMap(
                polygons: polygon,
                mapType: MapType.hybrid,
                // minMaxZoomPreference: MinMaxZoomPreference(14, 18),
                initialCameraPosition: CameraPosition(
                  // tilt: 45,
                  zoom: snapshot["map"]["zoomLevel"] - 1,
                  target: LatLng(
                    snapshot["map"]["centerCoordinate"][0],
                    snapshot["map"]["centerCoordinate"][1],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        )),
      );
    } else {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Text(
                "Not Mapped Yet",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 69, 170, 173)),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          projectID: projectID,
                        ),
                      ),
                    );
                  },
                  child: Text("Map"),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
