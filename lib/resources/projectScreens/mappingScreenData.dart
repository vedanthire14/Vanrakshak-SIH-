// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vanrakshak/screens/projectScreens/mapXmlScreen.dart';
import 'package:vanrakshak/screens/projectScreens/satelliteMapping.dart';
import 'package:vanrakshak/widgets/project/NotCompleteCard.dart';
import 'package:vanrakshak/widgets/Dashboard/dashBoardDetailCard.dart';
import 'package:vanrakshak/widgets/project/bulletPoint.dart';
import 'package:vanrakshak/widgets/project/instructionsCard.dart';
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
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "DETAILS OF THE POLYGON AREA ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 69, 170, 173),
                      ),
                    ),
                    SizedBox(height: 10),
                    BulletPoint(
                      Title: "AREA NAME ",
                      Detail: "${snapshot["map"]["projectLocation"]}",
                    ),
                    BulletPoint(
                      Title: "AREA VALUE: ",
                      Detail:
                          "${snapshot["map"]["areaMeters"].toStringAsFixed(2)} m2",
                    ),
                    // BulletPoint(
                    //   Title: "LAT/LONG LIST: ",
                    //   Detail: snapshot["map"]["coordinatesList"].toString(),
                    // ),
                   Container(
  height: 600, // Fixed height for the container
  child: ListView.builder(
    itemCount: snapshot["map"]["coordinatesList"].length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(8.0), // Padding around each card
        child: Card(
          elevation: 4.0, // Shadow effect
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0), // Padding inside the card
              child: BulletPoint(
                Title: "", // Assuming Title is optional or not needed here
                Detail: snapshot["map"]["coordinatesList"][index].toString(),
              ),
            ),
          ),
        ),
      );
    },
  ),
),

                  ],
                ),
              ),
              SizedBox(height: 20),
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
                  text: "SATELLITE IMAGE WITH POLYGON"),
              SizedBox(
                height: 30,
              ),

              SizedBox(height: 20),
              //HERE Google Maps Card
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
      //Map widget for not mapped
      GoogleMap googleMapWidget = GoogleMap(
          initialCameraPosition: CameraPosition(
              zoom: 10,
              target: LatLng(
                  //Mumbai Coordinates
                  19.0760,
                  72.8777)));

      //main Code for not mapped
      return SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 239, 248, 222),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          projectID: projectID,
                        ),
                      ),
                    );
                  },
                  child: NotCompleteCard(
                    title:
                        "A SATELLITE IMAGE IS REQUIRED TO GET THE CONSTRUCTION POLYGON AND PERFORM TREE ENUMERATION IN THE GIVEN AREA",
                    image: Image.asset('assets/project/projectTile25.png'),
                    MainTitle: "GOOGLE MAPS INTEGRATED",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 69, 170, 173),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MapScreen(
                                  projectID: projectID,
                                )),
                      );
                    },
                    child: Text("OPEN MAPS",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                // SizedBox(height: 20),
                // SizedBox(
                //   width: 250,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Color.fromARGB(255, 69, 170, 173),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(
                //             10.0), // Adjust the radius as needed
                //       ),
                //     ),
                //     onPressed: () {},
                //     child: Text("UPLOAD KML",
                //         style: TextStyle(color: Colors.white)),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                InstructionsCard(
                  cardItems: [
                    Text(
                      "STEPS FOR MAPPING",
                      style: TextStyle(
                        color: Color.fromARGB(255, 69, 170, 173),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    BulletPoint(
                      Title: "Mark The Points on Map",
                      Detail: "",
                    ),
                    BulletPoint(
                      Title: "Click the settings icon(bottom left)",
                      Detail: "",
                    ),
                    BulletPoint(
                      Title: "Click on download button",
                      Detail: "",
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
