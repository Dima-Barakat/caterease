import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/api_constants.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  // === PICKED IMAGE ===
  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    return _processPickedFile(pickedFile);
  }

  Future<File?> pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    return _processPickedFile(pickedFile);
  }

  Future<File?> _processPickedFile(XFile? file) async {
    if (file == null) return null;
    return File(file.path);
  }

  // === NETWORK IMAGE ===

  /// Returns the full image URL string
  String _getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return "${ApiConstants.imageUrl}/$path";
  }

  /// Returns a NetworkImage object from a relative path
  NetworkImage getNetworkImage(String? path) {
    final fullUrl = _getFullImageUrl(path);
    return NetworkImage(fullUrl);
  }
}
