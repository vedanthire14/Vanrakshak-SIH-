import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geodesy/geodesy.dart' as geodesy; // Added prefix here
import 'dart:math';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polygon Area Calculator',
      home: Maparea(),
    );
  }
}

class Maparea extends StatefulWidget {
  @override
  State<Maparea> createState() => MapareaState();
}

class MapareaState extends State<Maparea> {
  GoogleMapController? mapController;
  final List<LatLng> polygonCoords = [];
  double area = 0.0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      polygonCoords.add(position);
    });
  }

  void _calculateArea() {
    setState(() {
      // Convert Google Maps LatLng to Geodesy LatLng
      List<geodesy.LatLng> geodesyCoords = polygonCoords
          .map((coord) => geodesy.LatLng(coord.latitude, coord.longitude))
          .toList();

      area = PolygonAreaCalculator.calculateArea(geodesyCoords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        onTap: _onTap,
        polygons: Set.from([
          Polygon(
            polygonId: PolygonId('polygon'),
            points: polygonCoords,
            strokeWidth: 2,
            strokeColor: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.15),
          )
        ]),
        initialCameraPosition: CameraPosition(
          target: LatLng(19.0723, 72.8976),
          zoom: 14.0,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _calculateArea,
        label: Text('Calculate Area'),
        icon: Icon(Icons.map),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Text('Area: ${area.toStringAsFixed(2)} square units'),
      ),
    );
  }
}



class PolygonAreaCalculator {
  static double calculateArea(List<geodesy.LatLng> coords) {
    if (coords.length < 3) {
      return 0.0; // Not a polygon
    }

    double area = 0.0;
    int j = coords.length - 1; // The last vertex is the 'previous' one to the first

    for (int i = 0; i < coords.length; i++) {
      area += (degToRad(coords[j].longitude) - degToRad(coords[i].longitude)) *
              sin(degToRad(coords[i].latitude) + degToRad(coords[j].latitude)) / 2;
      j = i; // j is previous vertex to i
    }

    return area.abs() * 6378137.0 * 6378137.0; // Earth's radius in meters
  }

  static double degToRad(double degree) {
    return degree * (pi / 180.0);
  }
}
