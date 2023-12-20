import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xml/xml.dart' as xml;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class KMLMapScreen extends StatefulWidget {
  @override
  _KMLMapScreenState createState() => _KMLMapScreenState();
}

class _KMLMapScreenState extends State<KMLMapScreen> {
  List<String> kmlElements = [];

  @override
  void initState() {
    super.initState();
    // You can call _loadKMLFileAndDisplayContent() here if you want to load the file immediately
  }

  Future<void> _loadKMLFileAndDisplayContent() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;
      String fileContent;
      if (fileBytes != null) {
        fileContent = utf8.decode(fileBytes);
      } else {
        print('No file selected or file is not supported');
        return;
      }
      _parseKMLFile(fileContent);
    } else {
      print('File picking cancelled or failed');
    }
  }

  void _parseKMLFile(String kmlData) {
    var document = xml.XmlDocument.parse(kmlData);
    List<String> elementsList = [];
    var placemarks = document.findAllElements('Placemark');
    for (var placemark in placemarks) {
      elementsList.add(placemark.toXmlString(pretty: true, indent: '\t'));
    }
    setState(() {
      kmlElements = elementsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KML File Contents'),
      ),
      body: ListView.builder(
        itemCount: kmlElements.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Element $index'),
            subtitle: Text(kmlElements[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadKMLFileAndDisplayContent,
        child: Icon(Icons.file_upload),
      ),
    );
  }
}
