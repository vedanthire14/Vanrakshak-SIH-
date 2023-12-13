import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//AREA AND COORDINATES CARD
class AreaCoordinateCard extends StatelessWidget {
  final String areaOfMarkedRegion;
  final List<String> polygonCoordinates;

  AreaCoordinateCard(
      {Key? key,
      required this.areaOfMarkedRegion,
      required this.polygonCoordinates})
      : super(key: key);

  final Color Bgcolor = Color.fromARGB(255, 39, 159, 130);
  final Color Frontcolor = Color.fromARGB(255, 239, 248, 222);
  final Color buttoncolor = Color.fromARGB(255, 69, 170, 173);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Frontcolor,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildCoordinatesCard(),
            SizedBox(height: 10),
            _buildAreaCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinatesCard() {
    return Card(
      color: Frontcolor,
      elevation: 2, // Reduced elevation for nested card
      child: Padding(
        padding: EdgeInsets.all(8.0), // Adjust padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailText("Co-Ordinates", Icons.map),
            SizedBox(height: 6),
            ...polygonCoordinates
                .map((coordinate) => Text(
                      coordinate,
                      style: GoogleFonts.openSans(fontSize: 16),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard() {
    return Card(
      color: Frontcolor,
      elevation: 2, // Reduced elevation for nested card
      child: Row(
        children: [
          Expanded(
            child: Image.asset('assets/project/projectTile50.png',
                fit: BoxFit.cover), // Your image
          ),
          VerticalDivider(
            thickness: 1,
            color: Colors.grey[400],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0), // Add padding for text
              child: Text(
                "Area: $areaOfMarkedRegion",
                style: GoogleFonts.openSans(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        SizedBox(width: 8),
        Text(
          text,
          style:
              GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
