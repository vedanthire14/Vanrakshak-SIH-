import 'package:flutter/material.dart';

import 'package:vanrakshak/widgets/project/bulletPoint.dart';

class DashBoardDetailCard extends StatelessWidget {
  final String location;
  final String state;
  final String coordinate1;
  final String coordinate2;
  final String coordinate3;
  final String coordinate4;
  final String acres;
  final String metersSquared;

  DashBoardDetailCard({
    Key? key,
    required this.location,
    required this.state,
    required this.coordinate1,
    required this.coordinate2,
    required this.coordinate3,
    required this.coordinate4,
    required this.acres,
    required this.metersSquared,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 7.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Project Details
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("PROJECT DETAILS",
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                BulletPoint(Title: "Location: ", Detail: location),
                BulletPoint(Title: "State: ", Detail: state),
              ],
            ),
          ),
          Divider(indent: 20, endIndent: 20),

          //  Coordinates
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("COORDINATES",
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Container(
                  width: 280,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BulletPoint(Title: "", Detail: coordinate1),
                      BulletPoint(Title: "", Detail: coordinate2),
                    ],
                  ),
                ),
                Container(
                  width: 280,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BulletPoint(Title: "", Detail: coordinate3),
                      BulletPoint(Title: "", Detail: coordinate4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(indent: 20, endIndent: 20),

          // Area Details
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("AREA DETAILS",
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                BulletPoint(Title: "Acres: ", Detail: acres),
                BulletPoint(Title: "Meters Squared: ", Detail: metersSquared),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
