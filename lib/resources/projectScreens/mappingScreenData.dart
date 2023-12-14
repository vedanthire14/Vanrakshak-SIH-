// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vanrakshak/screens/projectScreens/satelliteMapping.dart';
import 'package:vanrakshak/widgets/project/bulletPoint.dart';
import 'package:vanrakshak/widgets/project/mappingScreen/mapImageCard.dart';

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
    // final screenSize = MediaQuery.of(context).size;
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

      GoogleMap googleMapWidget = GoogleMap(
        polygons: polygon,
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          zoom: snapshot["map"]["zoomLevel"] - 1,
          target: LatLng(
            snapshot["map"]["centerCoordinate"][0],
            snapshot["map"]["centerCoordinate"][1],
          ),
        ),
      );

      return SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 239, 248, 222),
          child: Center(
              child: Column(
            children: [
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("DETAILS OF THE POLYGON AREA ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  BulletPoint(
                    Title: "AREA NAME ",
                    Detail: "${snapshot["map"]["areaName"]}",
                  ),
                  BulletPoint(
                    Title: "AREA VALUE: ",
                    Detail: "${snapshot["map"]["areaValue"]}",
                  ),
                  BulletPoint(
                    Title: "LAT/LONG LIST: ",
                    Detail: "123456",
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),

              SizedBox(height: 20),
              MapImageCard(
                  imageUrl: snapshot["map"]
                      ["satelliteImageWithPolygonUnmasked"],
                  text: "Satellite Image With Polygon"),
              SizedBox(
                height: 30,
              ),

              SizedBox(height: 20),
              //HERE
              GoogleMapsCard(
                googleMap: googleMapWidget,
                cardWidth: MediaQuery.of(context).size.width *
                    0.9, // Set the card width based on screen width
                mapHeight: 300, // Set the height of the GoogleMap widget
              ),
              //TO HERE

              SizedBox(height: 50),
            ],
          )),
        ),
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
