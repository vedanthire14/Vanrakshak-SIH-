// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vanrakshak/resources/api/apiClass.dart';
import 'package:vanrakshak/resources/api/apiResponse.dart';
import 'package:vanrakshak/widgets/project/NotCompleteCard.dart';
import 'package:vanrakshak/widgets/Dashboard/dashBoardDetailCard.dart';
import 'package:vanrakshak/widgets/project/bulletPoint.dart';
import 'package:vanrakshak/widgets/project/instructionsCard.dart';
import 'package:vanrakshak/widgets/project/mappingScreen/mapImageCard.dart';

class EnumScreenData extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  bool loading = false;
  ApiAddress apiAddress = ApiAddress();

  void uploadDroneVideo(String projectID) async {
    final operationImageRef = FirebaseStorage.instance
        .ref()
        .child("DroneVideos/${projectID}_____DroneVideo");
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.single.path!);

    try {
      loading = true;
      notifyListeners();
      operationImageRef
          .putFile(file)
          .snapshotEvents
          .listen((taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            // notifyListeners();
            break;
          case TaskState.paused:
            // ...
            break;
          case TaskState.success:
            String link = await operationImageRef.getDownloadURL();
            FirebaseFirestore.instance
                .collection("projects")
                .doc(projectID)
                .update({
              "isSpecies": true,
              "droneVideoLink": link,
            });
            loading = false;
            notifyListeners();
            break;
          case TaskState.canceled:
            loading = false;
            notifyListeners();
            break;
          case TaskState.error:
            loading = false;
            notifyListeners();
            break;
        }
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  SingleChildScrollView enumScreen(
    Map<String, dynamic>? snapshot,
    BuildContext context,
    String projectID,
  ) {
    if (snapshot!["isMapped"]) {
      if (snapshot["isEnumerated"]) {
        return SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 239, 248, 222),
            child: Center(
                child: Column(
              children: [
                SizedBox(height: 40),
                InstructionsCard(
                  cardItems: [
                    Text("Details of Enumeration: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    BulletPoint(
                      Title: "Tree Count: ",
                      Detail: "${snapshot["enum"]["treeCount"]}",
                    ),
                    BulletPoint(
                      Title: "Forest Area: ",
                      Detail: "${snapshot["enum"]["forestArea"]}",
                    ),
                    BulletPoint(
                      Title: "Non Forest Area: ",
                      Detail: "${snapshot["enum"]["nonForestArea"]}",
                    ),
                  ],
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
                    imageUrl: snapshot["enum"]["enumeratedImage"],
                    text: "TREE ENUMERATION IN AREA"),
                SizedBox(height: 20),
                MapImageCard(
                    imageUrl: snapshot["map"]["satelliteImageWithNoPolygon"],
                    text: "MARKED POLYGON IN AREA"),
                SizedBox(height: 20),
                SizedBox(height: 40),
              ],
            )),
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 239, 248, 222),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  MapImageCard(
                      imageUrl: snapshot["map"]["satelliteImageWithNoPolygon"],
                      text: "CONSTRUSTION POLYGON"),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 250,
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 69, 170, 173),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                        ),
                        onPressed: () async {
                          loading = true;
                          notifyListeners();
                          String url;
                          if (snapshot["title"] == 'validation') {
                            url =
                                // "http://${apiAddress.address}:5000/treeEnumeration?ProjectID=$projectID&imageLink=${snapshot["map"]["satelliteImageWithNoPolygon"]}";
                                "http://${apiAddress.address}:5000/treeEnumerationn?ProjectID=$projectID&imageLink=${snapshot["map"]["satelliteImageWithNoPolygon"]}";
                          } else if (snapshot["title"] == 'dense') {
                            url =
                                "http://${apiAddress.address}:5000/treeEnumerationd?ProjectID=$projectID&imageLink=${snapshot["map"]["satelliteImageWithNoPolygon"]}";
                          } else {
                            url =
                                "http://${apiAddress.address}:5000/treeEnumeration?ProjectID=$projectID&imageLink=${snapshot["map"]["satelliteImageWithNoPolygon"]}";
                          }

                          // "http://10.0.2.2:5000/treeEnumeration?ProjectID=$projectID&imageLink=${snapshot["map"]["satelliteImageWithNoPolygon"]}";

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
                              "forestArea": decodedData["forestArea"],
                              "nonForestArea": decodedData['nonForestArea']
                            }
                          }).then((value) {
                            loading = false;
                            notifyListeners();
                          });

                          snapshot["isEnumerated"] = true;
                          snapshot["enum"] = {
                            "enumeratedImage": imageLink,
                            "treeCount": treeCount,
                            "forestArea": decodedData["forestArea"],
                            "nonForestArea": decodedData['nonForestArea']
                          };
                          notifyListeners();
                        },
                        child: Text("ENUMERATE",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InstructionsCard(cardItems: [
                    Text(
                      "STEPS FOR ENUMERATION",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    BulletPoint(
                        Title: "Perform Mapping if not done", Detail: ""),
                    BulletPoint(
                      Title: "Click on the Enumerate button",
                      Detail: "",
                    ),
                    BulletPoint(
                      Title: "Details of the Tree will be shown",
                      Detail: "",
                    ),
                  ])
                ],
              ),
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
                height: 20,
              ),
              NotCompleteCard(
                title:
                    "A SATELLITE IMAGE IS REQUIRED TO GET THE CONSTRUCTION POLYGON AND PERFORM TREE ENUMERATION IN THE GIVEN AREA",
                image: Image.asset('assets/project/projectTile25.png'),
                MainTitle: "COMPLETE MAPPING FIRST",
              ),
              SizedBox(height: 10),
              Text("or"),
              SizedBox(
                width: 250,
                child: SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 69, 170, 173),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                      ),
                    ),
                    onPressed: () async {
                      loading = true;
                      notifyListeners();

                      String url =
                          "http://${apiAddress.address}:5000/treeEnumeration?ProjectID=$projectID&imageLink=${snapshot["map"]["satelliteImageWithNoPolygon"]}";
                      // "http://10.0.2.2:5000/treeEnumeration?ProjectID=$projectID&imageLink=${snapshot["map"]["satelliteImageWithNoPolygon"]}";

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
                    },
                    child: Text("UPLOAD IMAGE",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
            ],
          ),
        ),
      );
    }
  }
}
