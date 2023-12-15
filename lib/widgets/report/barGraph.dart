import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MultiColorBarGraph extends StatelessWidget {
  final List<double> clayMeans;
  final List<double> siltMeans;
  final List<double> sandMeans;

  const MultiColorBarGraph({
    Key? key,
    required this.clayMeans,
    required this.siltMeans,
    required this.sandMeans,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // Adjusted height for a more compact presentation
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            padding: EdgeInsets.only(bottom: 30),
            child: _buildYAxisLabels(),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: BarChart(mainBarData()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYAxisLabels() {
    const int numberOfLabels = 6; // Including 0
    const double maxValue = 50; // Maximum value
    final double interval = maxValue / (numberOfLabels - 1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10), // Adjust as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(numberOfLabels, (index) {
          double labelValue = maxValue - (index * interval);
          return Text(
            labelValue.toStringAsFixed(0), // No decimal places
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 50,
      barGroups: _buildBarGroups(),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('Depth ${value.toInt() + 1}'),
              );
            },
          ),
        ),
      ),
      gridData: FlGridData(
        show: true, // Set this to true to show grid lines
        drawHorizontalLine: true, // Draw horizontal lines
        horizontalInterval: 10, // Interval for horizontal lines
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xffe7e8ec),
            strokeWidth: 1,
          );
        },
      ), // Removed grid lines
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    const double barWidth = 18; // Adjusted bar width
    const double groupSpacing = 40; // Adjusted spacing between groups

    return List.generate(clayMeans.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: clayMeans[i],
            color: Colors.blue.shade300,
            width: barWidth,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: siltMeans[i],
            color: Colors.green.shade300,
            width: barWidth,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: sandMeans[i],
            color: Colors.yellow.shade300,
            width: barWidth,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        barsSpace: 0, // Space between individual bars within a group
      );
    }).toList();
  }
}
