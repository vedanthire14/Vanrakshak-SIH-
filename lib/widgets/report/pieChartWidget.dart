import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatefulWidget {
  final double sand;
  final double normal;
  final double bad;

  const PieChartWidget(
      {Key? key, required this.sand, required this.normal, required this.bad})
      : super(key: key);

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1; // For touch
  List<String> details = []; // Data to be displayed after touched index

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //Overflow Avoid karne
          height: 200,
          width: 200,
          child: PieChart(
            PieChartData(
              //This is the Touch Functionality
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event,
                        PieTouchResponse? pieTouchResponse) // Here
                    {
                  setState(() {
                    if (event is FlLongPressStart ||
                        event is FlLongPressEnd ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      details = [];
                    } else {
                      touchedIndex = pieTouchResponse.touchedSection!
                          .touchedSectionIndex; //  Here we get the index of the touched section of the pie chart
                      details = getDetailsForSection(touchedIndex);
                    }
                  });
                },
              ),
              startDegreeOffset: 180, // Rotate the chart by 180 degrees
              sectionsSpace: 0, // No space between sections
              centerSpaceRadius: 50, // Radius of the center
              sections:
                  buildSections(), // Here we get the sections of the pie chart
            ),
          ),
        ),
        if (details.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details.map((detail) => Text(detail)).toList(),
            ),
          ),
        ],
      ],
    );
  }

  List<PieChartSectionData> buildSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      //Add more subparts here
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.yellow,
            value: widget.sand,
            title: 'No in Yellow ${widget.sand}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: widget.normal,
            title: 'No in green ${widget.normal}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.red,
            value: widget.bad,
            title: 'No in red ${widget.bad}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
        default:
          return PieChartSectionData();
      }
    });
  }

  List<String> getDetailsForSection(int index) {
    switch (index) {
      case 0:
        return [
          'Nahi Karega in Yellow',
          'Nahi Karega in Yellow',
          'Nahi Karega in Yellow',
          'Nahi Karega in Yellow'
        ];
      case 1:
        return [
          'Nahi Karega in Green',
          'Nahi Karega in Green',
          'Nahi Karega in Green',
          'Nahi Karega in Green'
        ];
      case 2:
        return [
          'Nahi Karega in Red',
          'Nahi Karega in Red',
          'Nahi Karega in Red',
          'Nahi Karega in Red'
        ];
      default:
        return [];
    }
  }
}
