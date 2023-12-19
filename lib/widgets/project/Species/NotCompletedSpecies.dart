import 'package:flutter/material.dart';

class NotCompleteSpecies extends StatefulWidget {
  final String title; // This will be inside the image boundary
  final Image image;
  final String button1Text; // Text for the first button
  final String button2Text; // Text for the second button
  final VoidCallback? onButton1Tap; // onTap action for the first button
  final VoidCallback? onButton2Tap; // onTap action for the second button

  NotCompleteSpecies({
    Key? key,
    required this.title,
    required this.image,
    required this.button1Text,
    required this.button2Text,
    this.onButton1Tap,
    this.onButton2Tap,
  }) : super(key: key);

  @override
  _NotCompleteSpeciesState createState() => _NotCompleteSpeciesState();
}

class _NotCompleteSpeciesState extends State<NotCompleteSpecies> {
  final Color borderColor = Colors.teal; // Teal color for the border

  Widget _buildImageWithTitle() {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 4),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 290,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: widget.image,
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: SizedBox(
        width: double.infinity, // Make button width as wide as possible
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.teal, // Teal color for the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: onTap,
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        color: const Color.fromARGB(255, 255, 255, 255),
        elevation: 14.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildImageWithTitle(),
              _buildButton(widget.button1Text, widget.onButton1Tap),
              _buildButton(widget.button2Text, widget.onButton2Tap),
            ],
          ),
        ),
      ),
    );
  }
}
