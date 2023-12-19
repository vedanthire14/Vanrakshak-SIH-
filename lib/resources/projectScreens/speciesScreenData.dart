import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vanrakshak/resources/api/apiClass.dart';
import 'package:vanrakshak/resources/api/apiResponse.dart';
import 'package:vanrakshak/widgets/project/Species/CarouselCard.dart';
import 'dart:io';
import 'package:vanrakshak/widgets/project/Species/NotCompletedSpecies.dart';
import 'package:vanrakshak/widgets/project/bulletPoint.dart';
import 'package:vanrakshak/widgets/project/instructionsCard.dart';

class SpeciesScreenData extends ChangeNotifier {
  bool loading = false;
  ApiAddress apiAddress = ApiAddress();

  void uploadDroneVideo(String projectID) async {
    final operationImageRef = FirebaseStorage.instance
        .ref()
        .child("DroneVideos/${projectID}_____DroneVideo");
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.single.path!);

    // try {
    //   loading = true;
    //   notifyListeners();
    //   operationImageRef
    //       .putFile(file)
    //       .snapshotEvents
    //       .listen((taskSnapshot) async {
    //     switch (taskSnapshot.state) {
    //       case TaskState.running:
    //         // notifyListeners();
    //         break;
    //       case TaskState.paused:
    //         // ...
    //         break;
    //       case TaskState.success:
    //         String link = await operationImageRef.getDownloadURL();
    //         FirebaseFirestore.instance
    //             .collection("projects")
    //             .doc(projectID)
    //             .update({
    //           "isSpecies": true,
    //           "droneVideoLink": link,
    //         });
    //         loading = false;
    //         notifyListeners();
    //         break;
    //       case TaskState.canceled:
    //         loading = false;
    //         notifyListeners();
    //         break;
    //       case TaskState.error:
    //         loading = false;
    //         notifyListeners();
    //         break;
    //     }
    //   });
    // } on FirebaseException catch (e) {
    //   print(e);
    // }
  }

  SingleChildScrollView speciesScreen(
    Map<String, dynamic>? snapshot,
    BuildContext context,
    String projectID,
  ) {
    final screenSize = MediaQuery.of(context).size;
    if (snapshot!["isSpecies"]) {
      // snapshot["species"]['imagesLink']
      return SingleChildScrollView(
          child: Center(
        child: Text("Hogaya"),
      ));
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            NotCompleteSpecies(
                title: "YOO",
                image: Image.asset('assets/project/projectTile25.png'),
                button1Text: "DRONE IMAGE",
                button2Text: "DRONE VIDEO",
                onButton1Tap: () {},
                onButton2Tap: () async {
                  uploadDroneVideo(projectID);
                  loading = true;
                  notifyListeners();
                  String url =
                      "http://${apiAddress.address}:5000/speciesDetection?ProjectID=$projectID";
                  // "http://10.0.2.2:5000/treeEnumeration?ProjectID=$projectID&imageLink=${snapshot["map"]["satelliteImageWithNoPolygon"]}";

                  Uri uri = Uri.parse(url);
                  var data = await apiResponse(uri);
                  var decodedData = jsonDecode(data);
                  print(decodedData['result']);
                  if (decodedData['result'] == "done") {
                    loading = false;
                    snapshot["isSpecies"] = true;
                    snapshot["species"] = {
                      "speciesList": decodedData["speciesList"],
                      "imagesLinks": decodedData["imagesLink"]
                    };
                    notifyListeners();
                  }
                }),
            SizedBox(height: 20),
            Divider(
              color: Colors.black,
              thickness: 2,
              indent: screenSize.width * 0.1,
              endIndent: screenSize.width * 0.1,
            ),
            SizedBox(height: 20),
            InstructionsCard(
              cardItems: [
                Text(
                  "STEPS FOR SPECIES DETECTION",
                  style: TextStyle(
                    color: Color.fromARGB(255, 69, 170, 173),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                BulletPoint(
                  Title: "Upload a drone video of area",
                  Detail: "",
                ),
                BulletPoint(
                  Title: "Conversion of video to segmented image",
                  Detail: "",
                ),
                BulletPoint(
                  Title: "Species will be detected",
                  Detail: "",
                )
              ],
            ),
          ],
        ),
      );
    }
  }
}
