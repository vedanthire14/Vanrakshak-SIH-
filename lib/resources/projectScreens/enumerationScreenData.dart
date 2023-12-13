// ignore_for_file: prefer_const_constructors
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
    if (snapshot!["isMapped"]) {
      if (snapshot["isEnumerated"]) {
        return SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Details of Enumeration: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              Divider(
                color: Colors.black,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(height: 20),
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
                snapshot["map"]["satelliteImageWithPolygonMasked"],
                height: 300,
              ),
              SizedBox(height: 40),
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
                Image.network(
                  snapshot["map"]["satelliteImageWithPolygonMasked"],
                  height: 300,
                  fit: BoxFit.cover,
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
            children: const [
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

class BulletPoint extends StatelessWidget {
  final String Title;
  final String Detail;

  BulletPoint({required this.Title, required this.Detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: Colors.teal,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10),
        Text(Title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Text(Detail, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
