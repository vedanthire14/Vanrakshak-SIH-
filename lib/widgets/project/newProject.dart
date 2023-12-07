// ignore_for_file: file_names
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CreateProjectWid extends StatefulWidget {
  const CreateProjectWid({super.key});

  @override
  State<CreateProjectWid> createState() => _CreateProjectWidState();
}

class _CreateProjectWidState extends State<CreateProjectWid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.0),
      ),
      margin: const EdgeInsets.all(16.0),
      child: DottedBorder(
        dashPattern: const [10, 2],
        strokeWidth: 1,
        radius: const Radius.circular(12.0),
        borderType: BorderType.RRect,
        color: const Color.fromARGB(255, 69, 170, 173),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '+ Create New Project',
                  style: TextStyle(
                    color: Color.fromARGB(255, 69, 170, 173),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
