import 'package:flutter/material.dart';

class NotCompleteCard extends StatefulWidget {
  final String title; // This will be inside the image boundary
  final Image image;
  final String MainTitle; // This will be outside and larger

  NotCompleteCard({
    Key? key,
    required this.title,
    required this.image,
    required this.MainTitle,
  }) : super(key: key);

  @override
  _NotCompleteCardState createState() => _NotCompleteCardState();
}

class _NotCompleteCardState extends State<NotCompleteCard> {
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
                fontSize:
                    12.0, // Smaller font size for the title inside the image
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTitle() {
    return Text(
      widget.MainTitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22.0, // Larger font size for the MainTitle outside the image
        fontWeight: FontWeight.bold,
        color: Colors.teal,
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
              const SizedBox(height: 16.0),
              _buildMainTitle(),
            ],
          ),
        ),
      ),
    );
  }
}
