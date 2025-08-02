import 'dart:convert';
import 'package:flutter/material.dart';

class Base64ImageWidget extends StatelessWidget {
  final String? base64String;
  final double height;
  final double width;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color placeholderColor;
  final IconData placeholderIcon;
  final Color placeholderIconColor;

  const Base64ImageWidget({
    Key? key,
    required this.base64String,
    this.height = 180,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderColor = const Color(0xFFE6E6E6),
    this.placeholderIcon = Icons.broken_image,
    this.placeholderIconColor = Colors.redAccent,
  }) : super(key: key);

  Widget _placeholder(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Container(
        height: height,
        width: width,
        color: placeholderColor,
        child: Icon(
          placeholderIcon,
          color: placeholderIconColor,
          size: 50,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // حماية من النص الفارغ، null أو "null"
    final str = base64String?.trim() ?? '';
    if (str.isEmpty || str.toLowerCase() == 'null') {
      return _placeholder(context);
    }

    try {
      // تنظيف النص من أي أسطر أو فراغات أو اقتباسات
      String cleanedBase64 = str
          .replaceAll('\n', '')
          .replaceAll('\r', '')
          .replaceAll(' ', '')
          .replaceAll('"', '');
      // إزالة البادئة إذا كانت موجودة (data:image/xxx;base64,)
      if (cleanedBase64.contains(',')) {
        cleanedBase64 = cleanedBase64.split(',').last;
      }
      // التأكد من padding صحيح (عدد المحارف يقبل القسمة على 4)
      int mod = cleanedBase64.length % 4;
      if (mod > 0) {
        cleanedBase64 += '=' * (4 - mod);
      }

      final bytes = base64Decode(cleanedBase64);

      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.memory(
          bytes,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            // في حال فشل Image.memory في العرض لأي سبب
            return _placeholder(context);
          },
        ),
      );
    } catch (_) {
      // أي خطأ في فك الشيفرة
      return _placeholder(context);
    }
  }
}
