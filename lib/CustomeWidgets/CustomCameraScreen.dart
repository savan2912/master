import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CustomCameraScreen extends StatefulWidget {
  const CustomCameraScreen({super.key});

  @override
  State<CustomCameraScreen> createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<CustomCameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  int selectedCameraIndex = 0; // 🔥 camera index
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras != null && cameras!.isNotEmpty) {
        await _initController(selectedCameraIndex);
      }
    } catch (e) {
      print("Camera setup error: $e");
    }
  }

  Future<void> _initController(int cameraIndex) async {
    _controller?.dispose();

    _controller = CameraController(
      cameras![cameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();

    if (!mounted) return;

    setState(() {
      _isInitialized = true;
    });
  }

  // 🔥 CAMERA SWITCH FUNCTION
  void _switchCamera() async {
    if (cameras == null || cameras!.length < 2) return;

    selectedCameraIndex =
    selectedCameraIndex == 0 ? 1 : 0;

    setState(() {
      _isInitialized = false;
    });

    await _initController(selectedCameraIndex);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: CameraPreview(_controller!)),

          // 🔙 BACK BUTTON
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 🔄 SWITCH CAMERA BUTTON
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.flip_camera_ios,
                  color: Colors.white, size: 28),
              onPressed: _switchCamera,
            ),
          ),

          // 📸 CAPTURE BUTTON
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () async {
                  try {
                    final XFile image =
                    await _controller!.takePicture();

                    Navigator.pop(context, File(image.path));
                  } catch (e) {
                    print("Capture error: $e");
                  }
                },
                child: const Icon(Icons.camera_alt,
                    color: Colors.black, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}