 import 'package:flutter/material.dart';

Widget buildLabel(String label) => Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 5),
        child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      );