// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vanrakshak/resources/api/apiResponse.dart';

class EnumScreenData extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  bool loading = false;

  SingleChildScrollView enumScreen(
    Map<String, dynamic>? snapshot,
    BuildContext context,
    String projectID,
  ) {
    final screenSize = MediaQuery.of(context).size;
    if (snapshot!["isMapped"]) {
      if (snapshot["isEnumerated"]) {
        return SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 5,
                        width: screenSize.width * 0.232,
                      ),
                      Container(
                        color: Color.fromARGB(255, 69, 170, 173),
                        height: 5,
                        width: screenSize.width * 0.232,
                      ),
                      SizedBox(
                        height: 5,
                        width: screenSize.width * 0.232,
                      ),
                      SizedBox(
                        height: 5,
                        width: screenSize.width * 0.232,
                      ),
                    ]),
              ),
              Text(
                "Marked Polygon Area",
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
              Text(
                "Tree Enumeration In Area",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Image.network(
                snapshot["enum"]["enumeratedImage"],
                height: 300,
              ),
              SizedBox(height: 20),
              Text(
                "Total Trees in Polygon - ${snapshot["enum"]["treeCount"]}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
            ],
          )),
        );
      } else {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 5,
                          width: screenSize.width * 0.232,
                        ),
                        Container(
                          color: Color.fromARGB(255, 69, 170, 173),
                          height: 5,
                          width: screenSize.width * 0.232,
                        ),
                        SizedBox(
                          height: 5,
                          width: screenSize.width * 0.232,
                        ),
                        SizedBox(
                          height: 5,
                          width: screenSize.width * 0.232,
                        ),
                      ]),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Marked Polygon Area",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      snapshot["map"]["satelliteImageWithPolygonUnmasked"],
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Enumeration Not Completed Yet",
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
                    onPressed: () async {
                      loading = true;
                      notifyListeners();

                      String url =
                          "http://10.0.2.2:5000/treeEnumeration?ProjectID=$projectID&imageLink=${snapshot["map"]["satelliteImageWithPolygonMasked"]}";

                      Uri uri = Uri.parse(url);
                      var data = await apiResponse(uri);
                      var decodedData = jsonDecode(data);
                      int treeCount = decodedData['treeCount'];
                      String imageLink = decodedData['enumeratedImageLink'];

                      FirebaseFirestore.instance
                          .collection("projects")
                          .doc(projectID)
                          .update({
                        "isEnumerated": true,
                        "enum": {
                          "enumeratedImage": imageLink,
                          "treeCount": treeCount,
                        }
                      }).then((value) {
                        loading = false;
                        notifyListeners();
                      });

                      snapshot["isEnumerated"] = true;
                      snapshot["enum"] = {
                        "enumeratedImage": imageLink,
                        "treeCount": treeCount,
                      };
                      notifyListeners();

                      // String url =
                      //     "http://10.0.2.2:5000/treecount?imgPath=${snapshot.data!["map"]["satelliteImageWithPolygonMasked"]}&ProjectID=$PID";

                      // Uri uri = Uri.parse(url);
                      // var data = await DownloadImage(uri);
                      // var decodedData = jsonDecode(data);
                      // var queryText = decodedData['treesnumber'];
                      // print(queryText);
                      //
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => MapSample(
                      //       projectID: PID,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Text("Enumerate"),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Text(
                "Please Complete Mapping First",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
