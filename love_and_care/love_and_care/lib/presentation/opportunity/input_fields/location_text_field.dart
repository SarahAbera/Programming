import 'package:flutter/material.dart';

class LocationTextField extends StatelessWidget {
  final TextEditingController controller;

  const LocationTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Location',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the location';
        }
        return null;
      },
    );
  }
}
