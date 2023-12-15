import 'package:flutter/material.dart';
import 'package:vanrakshak/widgets/report/barGraph.dart';

import 'package:vanrakshak/widgets/report/pieChartWidget.dart';
import 'package:vanrakshak/widgets/report/multiLineGraphWid.dart';

class SoilAnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soil Analysis'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            MultiColorBarGraph(
              clayMeans: [
                5,
                10,
                20,
              ],
              siltMeans: [
                7,
                14,
                22,
              ],
              sandMeans: [
                10,
                20,
                28,
              ],
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Icon(Icons.legend_toggle, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Sand"),
                  SizedBox(width: 8),
                  Icon(Icons.legend_toggle,
                      color: Color.fromARGB(255, 243, 159, 33)),
                  SizedBox(width: 8),
                  Text("Clay"),
                ],
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Label for Y-axis (Mean) rotated
                RotatedBox(
                  quarterTurns: 3, // this will rotate the text
                  child: Text('Mean', style: TextStyle(fontSize: 16)),
                ),
                Expanded(child: buildSoilAnalysisGraph()),
              ],
            ),
            // Label for X-axis (Depth)
            Center(child: Text('Depth', style: TextStyle(fontSize: 16))),

            SizedBox(height: 30),
            Text("Kya Chinmay Kaam Karega??", style: TextStyle(fontSize: 30)),

            PieChartWidget(
                sand: 20,
                normal: 50,
                bad:
                    30) // This will create a pie chart  for sand, normal, and bad.
          ],
        ),
      ),
    );
  }
}
//Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahahahahahhaha