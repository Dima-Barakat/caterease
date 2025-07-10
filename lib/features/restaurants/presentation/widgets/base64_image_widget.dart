import 'dart:convert';
import 'package:flutter/material.dart';

class Base64ImageWidget extends StatelessWidget {
  final String base64String;
  final double height;
  final double width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const Base64ImageWidget({
    Key? key,
    required this.base64String,
    this.height = 180,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      final cleanedBase64 = base64String
          .replaceAll('\n', '')
          .replaceAll('\r', '')
          .replaceAll(' ', '');

      final bytes = base64Decode(
        cleanedBase64.contains(',')
            ? cleanedBase64.split(',').last
            : cleanedBase64,
      );

      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.memory(
          bytes,
          height: height,
          width: width,
          fit: fit,
        ),
      );
    } catch (e) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Container(
          height: height,
          width: width,
          color: Colors.grey[200],
          child: const Icon(
            Icons.broken_image,
            color: Colors.redAccent,
            size: 50,
          ),
        ),
      );
    }
  }
}
