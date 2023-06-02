import 'package:flutter/material.dart';

class DescriptionTextField extends StatefulWidget {
  final TextEditingController controller;

  const DescriptionTextField({required this.controller});

  @override
  _DescriptionTextFieldState createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        height: isExpanded ? null : 72.0, // Adjust the height as needed
        child: TextField(
          controller: widget.controller,
          minLines: isExpanded ? null : 3,
          maxLines: isExpanded ? null : 3,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
