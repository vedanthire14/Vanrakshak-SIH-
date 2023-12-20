import 'package:flutter/material.dart';

class DashBoardFinalCardd extends StatelessWidget {
  final List<String> titles;
  final List<String> details;
  final List<String> coordinates;

  DashBoardFinalCardd({required this.titles, required this.details, required this.coordinates});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Dashboard Title',
                style: TextStyle(
                  color: Colors.teal,
                  decoration: TextDecoration.underline,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            ...List.generate(titles.length, (index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.fiber_manual_record, size: 16, color: Colors.teal),
                  SizedBox(width: 5),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: '${titles[index]}: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16, 
                          color: Colors.black
                        ),
                        children: [
                          TextSpan(
                            text: '${details[index]}',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Coordinate:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(width: 5),
                Text(coordinates.isNotEmpty ? coordinates.first : '', style: TextStyle(fontSize: 16)),
              ],
            ),
            ...coordinates.skip(1).map((coordinate) => Padding(
              padding: const EdgeInsets.only(left: 80.0), // Adjust padding to align with the first coordinate
              child: Text(coordinate, style: TextStyle(fontSize: 16)),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
