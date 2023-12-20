import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;
import 'package:vanrakshak/resources/api/apiClass.dart';
import 'package:vanrakshak/resources/api/apiResponse.dart';
import 'package:vanrakshak/screens/projectScreens/projectMainScreen.dart';
import 'package:vanrakshak/widgets/project/mappingScreen/locationInput.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Screen Web',
      home: MapScreenWeb(projectID: 'YOUR_PROJECT_ID'),
    );
  }
}

class MapScreenWeb extends StatefulWidget {
  final String projectID;

  const MapScreenWeb({Key? key, required this.projectID}) : super(key: key);

  @override
  State<MapScreenWeb> createState() => _MapScreenWebState();
}

class _MapScreenWebState extends State<MapScreenWeb> {
  String url = "http://10.0.2.2:5000/satelliteimage?LatLong=";
  final Set<Marker> _markers = {};
  List<LatLng> points = [];
  List<toolkit.LatLng> coordinates = [];
  bool loading = false;
  ApiAddress apiAddress = ApiAddress();
  double currentZoom = 15;
  Set<Polygon> _polygon = HashSet<Polygon>();
  Set<Marker> _marker = HashSet<Marker>();
  final TextEditingController _searchController = TextEditingController();
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(25.521502740705998, 91.55437264591455), zoom: 15);

  @override
  void initState() {
    super.initState();
    _controller = Completer<GoogleMapController>();
  }

  LatLng calculateCenter(List<LatLng> points) {
    var longitudes = points.map((i) => i.longitude).toList();
    var latitudes = points.map((i) => i.latitude).toList();
    latitudes.sort();
    longitudes.sort();
    var lowX = latitudes.first;
    var highX = latitudes.last;
    var lowy = longitudes.first;
    var highy = longitudes.last;
    var centerX = lowX + ((highX - lowX) / 2);
    var centerY = lowy + ((highy - lowy) / 2);
    return LatLng(centerX, centerY);
  }

  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  void onCameraMove(CameraPosition position) {
    setState(() {
      currentZoom = position.zoom;
      if (currentZoom == 0) {
        currentZoom = 15;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 69, 170, 173),
        title: const Text('Satellite Mapping', style: TextStyle(color: Color.fromARGB(255, 239, 248, 222))),
      ),
      backgroundColor: const Color.fromARGB(255, 239, 248, 222),
      body: (loading)
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 69, 170, 173)))
          : SafeArea(
              child: Stack(
                children: [
                  GoogleMap(
                    onCameraMove: onCameraMove,
                    polygons: _polygon,
                    markers: _marker,
                    onTap: (argument) {
                      points.add(argument);
                      coordinates.add(toolkit.LatLng(argument.latitude, argument.longitude));
                      setState(() {
                        _marker.add(Marker(
                          markerId: MarkerId(argument.toString()),
                          position: argument,
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        ));
                      });
                    },
                    mapType: MapType.hybrid,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                  Positioned(
                    top: 15,
                    left: 20,
                    right: 20,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'SEARCH',
                                hintStyle: TextStyle(color: Colors.black87),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.black87),
                              onSubmitted: (value) {
                                searchLocation(value);
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_searchController.text.isNotEmpty) {
                                searchLocation(_searchController.text);
                              }
                            },
                            icon: const Icon(Icons.search, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Align(alignment: Alignment.bottomLeft, child: buildSpeedDial()),
      ),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      backgroundColor: const Color.fromARGB(255, 69, 170, 173),
      gradientBoxShape: BoxShape.circle,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 69, 170, 173),
          Color.fromARGB(255, 69, 170, 173),
        ],
      ),
      children: [
        // ... Speed dial children ...
      ],
    );
  }

  Future<void> searchLocation(String query) async {
    // ... Search location implementation ...
  }
}
