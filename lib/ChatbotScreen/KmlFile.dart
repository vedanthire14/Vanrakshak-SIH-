import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vanrakshak/resources/api/apiClass.dart';
import 'package:vanrakshak/resources/api/apiResponse.dart';
import 'package:xml/xml.dart' as xml;
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;

class KMLFileUploadScreen extends StatefulWidget {
  @override
  _KMLFileUploadScreenState createState() => _KMLFileUploadScreenState();
}

class _KMLFileUploadScreenState extends State<KMLFileUploadScreen> {
  List<LatLng> coordinates = [];
  ApiAddress apiAddress = ApiAddress();
  var areaAcres = 0.0;
  String image = "";

  // Future<void> _pickAndParseKMLFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     String fileContent = String.fromCharCodes(result.files.single.bytes!);
  //     _parseKMLFile(fileContent);
  //   }
  // }

  Future<void> _pickAndParseKMLFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.bytes != null) {
      String fileContent = String.fromCharCodes(result.files.single.bytes!);
      _parseKMLFile(fileContent);
    } else {
      // Handle the situation when bytes are null or no file is picked
      print("No file selected or file is empty");
    }
  }

  void _parseKMLFile(String kmlData) async {
    var document = xml.XmlDocument.parse(kmlData);
    var placemarks = document.findAllElements('Placemark');

    List<LatLng> fetchedCoordinates = [];
    for (var placemark in placemarks) {
      var points = placemark.findAllElements('coordinates');
      if (points.isNotEmpty) {
        var coordString = points.first.text.trim();
        var coordParts = coordString.split(',');
        if (coordParts.length >= 2) {
          double? lat = double.tryParse(coordParts[1]);
          double? lon = double.tryParse(coordParts[0]);
          if (lat != null && lon != null) {
            fetchedCoordinates.add(LatLng(lat, lon));
          }
        }
      }
    }
    coordinates = fetchedCoordinates;
    String url = "http://${apiAddress.address}:5000/satelliteimage?LatLong=";
    for (int i = 0; i < coordinates.length; i++) {
      if (i == coordinates.length - 1) {
        url += "${coordinates[i].latitude},${coordinates[i].longitude}";
      } else {
        url += "${coordinates[i].latitude},${coordinates[i].longitude},";
      }
    }
    url += "&ProjectID=989898989898989";

    url += "&zoomlevel=16&xml=yes";
    Uri uri = Uri.parse(url);
    print(uri);
    var jsonData = await apiResponse(uri);
    var decodedData = jsonDecode(jsonData);
    print(decodedData["finalList"]);
    // List<double> finalList = decodedData["finalList"];
    List<dynamic> finalList = decodedData["finalList"];

    // .map((value) =>
    //     value is double ? value : double.tryParse(value.toString()) ?? 0.0)
    // .toList();
    List<toolkit.LatLng> listy = [];
    for (int i = 0; i < finalList.length; i += 2) {
      double lat = finalList[i];
      double lon = finalList[i + 1];
      listy.add(toolkit.LatLng(lat, lon));
    }

    var areaInSquareMeters =
        toolkit.SphericalUtil.computeArea(listy.cast<toolkit.LatLng>());

    setState(() {
      areaAcres = areaInSquareMeters / 4046.85642 / 2.5;
      image = decodedData['satelliteImageUnmasked'];
    });

    print(areaAcres);

    // setState(() {
    //   coordinates = fetchedCoordinates;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KML File Upload and Parse'),
      ),
      body: Stack(children: [
        ListView.builder(
          itemCount: coordinates.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Coordinate ${index + 1}'),
              subtitle: Text(
                  'Latitude: ${coordinates[index].latitude}, Longitude: ${coordinates[index].longitude}'),
            );
          },
        ),
        (areaAcres == 0) ? Text("") : Text("Area : " + areaAcres.toString()),
        // (image == "") ? Text("") : Image.network(image),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndParseKMLFile,
        child: Icon(Icons.file_upload),
      ),
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
