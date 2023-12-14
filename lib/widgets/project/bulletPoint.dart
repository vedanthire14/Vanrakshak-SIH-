import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  final String Title;
  final String Detail;

  BulletPoint({required this.Title, required this.Detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 10,
          width: 10,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 69, 170, 173),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          Title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          Detail,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
