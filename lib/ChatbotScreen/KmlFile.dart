import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:xml/xml.dart' as xml;

class KMLFileUploadScreen extends StatefulWidget {
  @override
  _KMLFileUploadScreenState createState() => _KMLFileUploadScreenState();
}

class _KMLFileUploadScreenState extends State<KMLFileUploadScreen> {
  List<LatLng> coordinates = [];

  Future<void> _pickAndParseKMLFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String fileContent = String.fromCharCodes(result.files.single.bytes!);
      _parseKMLFile(fileContent);
    }
  }

  void _parseKMLFile(String kmlData) {
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

    setState(() {
      coordinates = fetchedCoordinates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KML File Upload and Parse'),
      ),
      body: ListView.builder(
        itemCount: coordinates.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Coordinate ${index + 1}'),
            subtitle: Text('Latitude: ${coordinates[index].latitude}, Longitude: ${coordinates[index].longitude}'),
          );
        },
      ),
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
