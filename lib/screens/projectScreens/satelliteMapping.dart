// ignore_for_file: file_names
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemap;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;
import 'package:vanrakshak/resources/api/apiResponse.dart';
import 'package:vanrakshak/screens/projectScreens/projectMainScreen.dart';
import 'package:vanrakshak/widgets/project/mappingScreen/locationInput.dart';

class MapScreen extends StatefulWidget {
  final String projectID;

  const MapScreen({super.key, required this.projectID});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  String url = "http://10.0.2.2:5000/satelliteimage?LatLong=";
  final Set<googlemap.Marker> _markers = {};
  List<googlemap.LatLng> points = [];
  List<toolkit.LatLng> coordinates = [];
  bool loading = false;

  double currentZoom = 15;
  void onCameraMove(CameraPosition position) {
    setState(() {
      currentZoom = position.zoom;
      if (currentZoom == 0) {
        currentZoom = 15;
      }
    });
    print('Current Zoom: $currentZoom');
  }

  Set<googlemap.Polygon> _polygon = HashSet<googlemap.Polygon>();
  Set<googlemap.Marker> _marker = HashSet<googlemap.Marker>();
  final TextEditingController _searchController = TextEditingController();

  static const googlemap.CameraPosition _kGooglePlex = googlemap.CameraPosition(
    target: googlemap.LatLng(25.521502740705998, 91.55437264591455),
    zoom: 15,
  );

  googlemap.LatLng calculateCenter(List<googlemap.LatLng> points) {
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

    return googlemap.LatLng(centerX, centerY);
  }

  Completer<googlemap.GoogleMapController> _controller =
      Completer<googlemap.GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _controller = Completer<googlemap.GoogleMapController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 248, 222),
      body: (loading)
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 69, 170, 173)))
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 69, 170, 173),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search for a location...',
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
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: googlemap.GoogleMap(
                      // minMaxZoomPreference: MinMaxZoomPreference(15, 18),
                      onCameraMove: onCameraMove,
                      polygons: _polygon,
                      markers: _marker,
                      onTap: (argument) {
                        points.add(argument);
                        coordinates.add(toolkit.LatLng(
                            argument.latitude, argument.longitude));
                        setState(() {
                          _marker.add(googlemap.Marker(
                            markerId: googlemap.MarkerId(argument.toString()),
                            position: argument,
                            icon:
                                googlemap.BitmapDescriptor.defaultMarkerWithHue(
                                    googlemap.BitmapDescriptor.hueGreen),
                          ));
                        });
                        print(points);
                      },
                      mapType: googlemap.MapType.hybrid,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (googlemap.GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
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
        SpeedDialChild(
          child: const Icon(Icons.map),
          backgroundColor: const Color.fromARGB(255, 239, 248, 222),
          label: 'Add Marker',
          onTap: () {
            var areaInSquareMeters =
                toolkit.SphericalUtil.computeArea(coordinates);
            // print("List of coordinates of polygon : $coordinates");
            // print("Center Coordinate : ${calculateCenter(points).latitude}");
            // print("Area in meter square : $areaInSquareMeters");
            var areaAcres = areaInSquareMeters / 4046.85642;
            print("Area in acres : $areaAcres");

            setState(() {
              _polygon.add(
                googlemap.Polygon(
                  polygonId: const googlemap.PolygonId('1'),
                  points: points,
                  fillColor:
                      const Color.fromARGB(255, 37, 45, 203).withOpacity(0.5),
                  strokeColor: const Color.fromARGB(255, 37, 45, 203),
                  geodesic: true,
                  strokeWidth: 4,
                ),
              );
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.clear),
          backgroundColor: const Color.fromARGB(255, 239, 248, 222),
          label: 'Clear All',
          onTap: () {
            setState(() {
              coordinates.clear();
              points.clear();
              _polygon.clear();
              _marker.clear();
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.zoom_in),
          backgroundColor: const Color.fromARGB(255, 239, 248, 222),
          label: 'Zoom To Location',
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LocationDialog(
                  onLocationEntered: (coords) {
                    if (coords.isNotEmpty) {
                      setState(() {
                        coordinates = [];
                        points = [];
                        for (int i = 0; i < coords.length; i++) {
                          points.add(
                              googlemap.LatLng(coords[i]![0], coords[i]![1]));
                          coordinates.add(
                              toolkit.LatLng(coords[i]![0], coords[i]![1]));
                        }

                        _polygon = {};
                        _polygon.add(
                          googlemap.Polygon(
                            polygonId: const googlemap.PolygonId('1'),
                            points: points,
                            fillColor: const Color.fromARGB(255, 37, 45, 203)
                                .withOpacity(0.5),
                            strokeColor: const Color.fromARGB(255, 37, 45, 203),
                            geodesic: true,
                            strokeWidth: 4,
                          ),
                        );

                        _marker = {};
                        for (int i = 0; i < points.length; i++) {
                          _marker.add(
                            googlemap.Marker(
                              markerId: googlemap.MarkerId(i.toString()),
                              position: points[i],
                              icon: googlemap.BitmapDescriptor
                                  .defaultMarkerWithHue(
                                      googlemap.BitmapDescriptor.hueGreen),
                            ),
                          );
                        }
                      });
                    }
                  },
                );
              },
            );
          },
        ),
        SpeedDialChild(
          backgroundColor: const Color.fromARGB(255, 239, 248, 222),
          onTap: () async {
            // url = "http://10.0.22.67:5000/satelliteimage?LatLong=";
            setState(() {
              loading = true;
            });
            url = "http://10.0.2.2:5000/satelliteimage?LatLong="; //For Emulator
            for (int i = 0; i < coordinates.length; i++) {
              if (i == coordinates.length - 1) {
                url += "${coordinates[i].latitude},${coordinates[i].longitude}";
              } else {
                url +=
                    "${coordinates[i].latitude},${coordinates[i].longitude},";
              }
            }
            url += "&ProjectID=${widget.projectID}";
            var areaInSquareMeters =
                toolkit.SphericalUtil.computeArea(coordinates);
            var areaAcres = areaInSquareMeters / 4046.85642;

            url += "&zoomlevel=$currentZoom";

            Uri uri = Uri.parse(url);
            print(uri);
            var jsonData = await apiResponse(uri);
            var decodedData = jsonDecode(jsonData);
            String output = decodedData['result'];
            String satelliteImageLink = decodedData['satelliteImageUnmasked'];
            String matelliteImageMaskedLink =
                decodedData['satelliteImageMasked'];
            List elevationList = decodedData['elevationList'];
            print(output);
            if (output == "The map has successfully been created") {
              setState(() {
                loading = false;
              });
            }
            if (output == "The map has successfully been created") {
              List<double> databaseCoords = [];
              for (int i = 0; i < coordinates.length; i++) {
                databaseCoords.add(coordinates[i].latitude);
                databaseCoords.add(coordinates[i].longitude);
              }
              Map<String, dynamic> databaseUpdate = <String, dynamic>{
                "coordinatesList": databaseCoords,
                "centerCoordinate": [
                  calculateCenter(points).latitude,
                  calculateCenter(points).longitude
                ],
                "areaAcres": areaAcres,
                "areaMeters": areaInSquareMeters,
                "satelliteImageWithPolygonUnmasked": satelliteImageLink,
                "satelliteImageWithPolygonMasked": matelliteImageMaskedLink,
                "elevationList": elevationList,
                "zoomLevel": currentZoom
              };
              await FirebaseFirestore.instance
                  .collection("projects")
                  .doc(widget.projectID)
                  .update({
                "progress": 25.0,
                "isMapped": true,
                "map": databaseUpdate,
              }).then((value) {
                setState(() {
                  loading = false;
                });
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectMainScreen(projectID: widget.projectID)
                  ),
                );
              });
            } else {
              setState(() {
                loading = false;
              });
              print("Some Error Occured");
            }
          },
          child: const Icon(
            Icons.download,
          ),
        ),
      ],
      child: const Icon(
        Icons.add,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  Future<void> searchLocation(String query) async {
    const apiKey = 'AIzaSyC5QkMgaiQo3G7RH95BWJoqzWbKczWVCkU';
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];

      setState(() {
        _markers.clear();
        if (results.isNotEmpty) {
          final firstResult = results[0];
          final location = firstResult['geometry']['location'];
          final lat = location['lat'];
          final lng = location['lng'];
          print("Lat: $lat, Lng: $lng");

          _markers.add(
            googlemap.Marker(
              markerId: googlemap.MarkerId(firstResult['place_id']),
              position: googlemap.LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: firstResult['name'],
                snippet: firstResult['formatted_address'],
              ),
            ),
          );

          _controller.future.then((googlemap.GoogleMapController controller) {
            controller.animateCamera(
              CameraUpdate.newLatLng(
                googlemap.LatLng(lat, lng),
              ),
            );
          });
        }
      });
    }
  }
}
