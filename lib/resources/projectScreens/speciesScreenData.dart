import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vanrakshak/widgets/project/Species/CarouselCard.dart';
import 'dart:io';

import 'package:vanrakshak/widgets/project/Species/NotCompletedSpecies.dart';
import 'package:vanrakshak/widgets/project/bulletPoint.dart';
import 'package:vanrakshak/widgets/project/instructionsCard.dart';

class SpeciesScreenData extends ChangeNotifier {
  bool loading = false;

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

  SingleChildScrollView speciesScreen(
    Map<String, dynamic>? snapshot,
    BuildContext context,
    String projectID,
  ) {
    final screenSize = MediaQuery.of(context).size;
    if (snapshot!["isSpecies"]) {
      return SingleChildScrollView(
          child: Center(
        child: Text("Hogaya"),
      ));
    } else {
      List<String> images = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        // Add more image URLs
      ];

      List<List<String>> details = [
        ["Detail 1A", "Detail 1B", "Detail 1C", "Detail 1D"],
        ["Detail 2A", "Detail 2B", "Detail 2C", "Detail 2D"],
        // Add more details corresponding to each image
      ];

      return SingleChildScrollView(
        child: Column(
          children: [
            CarouselCard(imgList: images, details: details),
            SizedBox(height: 20),
            NotCompleteSpecies(
                title: "YOO",
                image: Image.asset('assets/project/projectTile25.png'),    
                button1Text: "OHHH",
                button2Text: "button2Text",
                onButton1Tap: () {},
                onButton2Tap: () {}),
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
