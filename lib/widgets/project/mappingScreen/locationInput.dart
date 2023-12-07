// ignore_for_file: library_private_types_in_public_api, file_names
import 'package:flutter/material.dart';

String url = "http://10.0.2.2:5000/folium?LatLong=";
String queryText = "";

class LocationDialog extends StatefulWidget {
  final Function(List<List<double>?> coordinates) onLocationEntered;

  const LocationDialog({super.key, required this.onLocationEntered});

  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  final TextEditingController _latitudeController1 =
      TextEditingController(text: '19.2197');
  final TextEditingController _longitudeController1 =
      TextEditingController(text: '72.9090');
  final TextEditingController _latitudeController2 =
      TextEditingController(text: '19.2195');
  final TextEditingController _longitudeController2 =
      TextEditingController(text: '72.9095');
  final TextEditingController _latitudeController3 = TextEditingController(
    text: '19.2163',
  );
  final TextEditingController _longitudeController3 =
      TextEditingController(text: '72.9139');
  final TextEditingController _latitudeController4 =
      TextEditingController(text: '19.2213');
  final TextEditingController _longitudeController4 = TextEditingController(
    text: '72.9139',
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Coordinates'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCoordinateTextField(
            controller: _latitudeController1,
            labelText: 'Latitude 1',
            longitudeController: _longitudeController1,
            labelText2: 'Longitude 1',
          ),
          _buildCoordinateTextField(
            controller: _latitudeController2,
            labelText: 'Latitude 2',
            longitudeController: _longitudeController2,
            labelText2: 'Longitude 2',
          ),
          _buildCoordinateTextField(
            controller: _latitudeController3,
            labelText: 'Latitude 3',
            longitudeController: _longitudeController3,
            labelText2: 'Longitude 3',
          ),
          _buildCoordinateTextField(
            controller: _latitudeController4,
            labelText: 'Latitude 4',
            longitudeController: _longitudeController4,
            labelText2: 'Longitude 4',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final coordinates = [
              _tryParseCoordinate(_latitudeController1, _longitudeController1),
              _tryParseCoordinate(_latitudeController2, _longitudeController2),
              _tryParseCoordinate(_latitudeController3, _longitudeController3),
              _tryParseCoordinate(_latitudeController4, _longitudeController4),
            ];
            widget.onLocationEntered(coordinates);
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }

  Widget _buildCoordinateTextField({
    required TextEditingController controller,
    required String labelText,
    required TextEditingController longitudeController,
    required String labelText2,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: labelText),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextField(
            controller: longitudeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: labelText2),
          ),
        ),
      ],
    );
  }

  List<double>? _tryParseCoordinate(TextEditingController latitudeController,
      TextEditingController longitudeController) {
    final latitude = double.tryParse(latitudeController.text);
    final longitude = double.tryParse(longitudeController.text);

    if (latitude != null && longitude != null) {
      return [latitude, longitude];
    } else {
      return null;
    }
  }
}
