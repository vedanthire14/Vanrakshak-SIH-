// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vanrakshak/resources/api/apiResponse.dart';
import 'package:vanrakshak/widgets/project/NotCompleteCard.dart';
import 'package:vanrakshak/widgets/Dashboard/dashBoardDetailCard.dart';
import 'package:vanrakshak/widgets/project/bulletPoint.dart';
import 'package:vanrakshak/widgets/project/instructionsCard.dart';
import 'package:vanrakshak/widgets/project/mappingScreen/mapImageCard.dart';

class EnumScreenData extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  bool loading = false;

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
                      Detail: "${snapshot["map"]["forestArea"]}",
                    ),
                    BulletPoint(
                      Title: "Total Area: ",
                      Detail: "${snapshot["map"]["totalArea"]}",
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

                          String url =
                              "http://10.0.2.2:5000/treeEnumeration?ProjectID=$projectID&imageLink=${snapshot["map"]["satelliteImageWithNoPolygon"]}";

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
            ],
          ),
        ),
      );
    }
  }
}
