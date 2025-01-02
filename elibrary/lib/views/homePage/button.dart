import 'package:flutter/material.dart';

class customButtonOne extends StatefulWidget {
  final String buttonText; // Text to display on the button
  final VoidCallback onPressed; // Function to execute when button is pressed

  const customButtonOne({
    Key? key,
    required this.buttonText,
    required this.onPressed, // Make onPressed a required parameter
  }) : super(key: key);

  @override
  State<customButtonOne> createState() => _customButtonOneState();
}

class _customButtonOneState extends State<customButtonOne> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed, // Use the passed-in callback
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
      child: Text(widget.buttonText),
    );
  }
}
