// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProjectCard extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final double progress;
  final bool isMapped;
  final bool isEnumerated;
  final bool isSpecies;
  final bool isReported;

  const ProjectCard({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.progress,
    required this.isMapped,
    required this.isEnumerated,
    required this.isSpecies,
    required this.isReported,
  });

  @override
  Widget build(BuildContext context) {
    final List<double> progressValues = [
      progress >= 25 ? 1.0 : 0.0,
      progress >= 50 ? 1.0 : 0.0,
      progress >= 75 ? 1.0 : 0.0,
      progress >= 100 ? 1.0 : 0.0,
    ];
final double cardWidth = kIsWeb
        ? MediaQuery.of(context).size.width * 0.6
        : MediaQuery.of(context).size.width * 0.6;
    return Container(
      width: cardWidth,
      margin: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 69, 170, 173),
                ),
              ),
              const SizedBox(height: 1.0),
              Row(
                children: [
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color.fromARGB(255, 69, 170, 173),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    "($date)",
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color.fromARGB(255, 69, 170, 173),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPointer('Mapping', isMapped),
                      _buildPointer('Enumeration', isEnumerated),
                      _buildPointer('Species', isSpecies),
                      _buildPointer('Reports', isReported),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Image.asset(
                      "assets/project/projectTile${progress.toString().split(".")[0]}.png",
                      height: 120,
                      width: 120,
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 10.0),
              // Text(
              //   '${progress.toString().split(".")[0]}% Completed',
              //   style: const TextStyle(
              //     fontSize: 16.0,
              //     color: Color.fromARGB(255, 69, 170, 173),
              //   ),
              // ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  for (var value in progressValues)
                    Expanded(
                      child: LinearProgressIndicator(
                        minHeight: 10.0,
                        value: value,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 69, 170, 173),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointer(String label, bool isChecked) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 24.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isChecked
                ? const Color.fromARGB(255, 69, 170, 173)
                : Colors.grey,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            color: isChecked ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }
}
