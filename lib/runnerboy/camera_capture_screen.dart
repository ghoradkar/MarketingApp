import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CameraCaptureScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraCaptureScreen({super.key, required this.camera});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isTaking = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<File?> _takePictureAndSave() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;
    if (_isTaking) return null;
    try {
      setState(() => _isTaking = true);
      final XFile xfile = await _controller!.takePicture();

      // Move to a temp file with proper extension
      final tempDir = await getTemporaryDirectory();
      final fileName =
          'sample_${DateTime.now().millisecondsSinceEpoch}${p.extension(xfile.path)}';
      final savedPath = p.join(tempDir.path, fileName);

      final file = await File(xfile.path).copy(savedPath);

      return file;
    } catch (e) {
      debugPrint('Error taking picture: $e');
      return null;
    } finally {
      if (mounted) setState(() => _isTaking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
                AppColor.secondaryColor.withValues(alpha: 0.3)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: CustomText(
          text: "Camera Preview",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textColor: AppColor.black,
          textAlign: TextAlign.start,
          fontFam: 'Nunito Sans',
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(child: CameraPreview(_controller!)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final file = await _takePictureAndSave();
                  if (file != null) {
                    Get.back(result: file);
                  } else {
                    CustomMessage.toast("Failed to capture image");
                  }
                },
                child: Container(
                  width: 72,
                  height: 72,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 6, color: Colors.white24),
                  ),
                  child: Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
