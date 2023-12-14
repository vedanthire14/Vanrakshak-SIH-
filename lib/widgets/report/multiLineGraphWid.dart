import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


Widget buildSoilAnalysisGraph() {
    final lineBarsData = [
      LineChartBarData(
        spots: const [
          FlSpot(0, 0),
          FlSpot(5, 10),
          FlSpot(15, 5),
          FlSpot(10, 15),
          FlSpot(20, 10),
          FlSpot(20, 5),
        ],
        color: Colors.blue,
      ),
      LineChartBarData(
        spots: const [
          FlSpot(0, 5),
          FlSpot(3, 10),
          FlSpot(7, 5),
          FlSpot(09, 5),
          FlSpot(5, 10),
          FlSpot(15, 5),
        ],
        color: Color.fromARGB(255, 243, 159, 33),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 300,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              rightTitles: AxisTitles(
                sideTitles:
                    SideTitles(showTitles: false), // Remove right titles
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Remove top titles
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()}');
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTitlesWidget: (value, meta) {
                    // Adjust the interval of X-axis labels
                    if (value == 0 || value % 5 == 0) {
                      return Text('${value.toInt()}');
                    }
                    return Container();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black),
            ),
            minX: 0,
            maxX: 20, // Adjust the maximum X value
            minY: 0,
            maxY: 20, // Adjust the maximum Y value as needed
            lineBarsData: lineBarsData,
          ),
        ),
      ),
    );
  }