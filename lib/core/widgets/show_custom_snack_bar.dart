import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  SnackBarType type = SnackBarType.info,
}) {
  Color bgColor;
  IconData icon;

  switch (type) {
    case SnackBarType.success:
      bgColor = Colors.green;
      break;
    case SnackBarType.error:
      bgColor = Colors.red;
      break;
    case SnackBarType.info:
    default:
      bgColor = Colors.grey[800]!;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: bgColor,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

enum SnackBarType { success, error, info }
