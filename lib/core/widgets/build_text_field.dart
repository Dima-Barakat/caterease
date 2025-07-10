import 'package:flutter/material.dart';



/// A reusable text field widget.
Widget buildTextField({
  required TextEditingController controller,
  required String hint,
  TextInputType keyboardType = TextInputType.text,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    readOnly: readOnly,
    onTap: onTap,
    decoration: inputDecoration(hintText: hint),
  );
}

/// A helper function for input decoration.
InputDecoration inputDecoration({String? hintText}) => InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
