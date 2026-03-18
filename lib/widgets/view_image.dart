import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final String? imagePath;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final String? title;

  const ImageViewer({
    super.key,
    this.imagePath,
    this.imageUrl,
    this.imageBytes,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (imageBytes != null) {
      imageProvider = MemoryImage(imageBytes!);
    } else if (imagePath != null) {
      imageProvider = FileImage(File(imagePath!));
    } else if (imageUrl != null) {
      imageProvider = NetworkImage(imageUrl!);
    }

    if (imageProvider == null) {
      return Scaffold(
        appBar: AppBar(title: Text(title ?? 'Image Viewer')),
        body: const Center(child: Text('No image provided')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title ?? 'Image Viewer')),
      body: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2.0,
      ),
    );
  }
}
