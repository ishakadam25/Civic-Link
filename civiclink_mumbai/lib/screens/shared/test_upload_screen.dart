import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/cloudinary_service.dart';

class TestUploadScreen extends StatefulWidget {
  const TestUploadScreen({super.key});

  @override
  State<TestUploadScreen> createState() => _TestUploadScreenState();
}

class _TestUploadScreenState extends State<TestUploadScreen> {
  File? _image;
  String? _imageUrl;
  bool _isUploading = false;

  Future<void> pickAndUpload() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    setState(() {
      _image = file;
      _isUploading = true;
      _imageUrl = null; // reset previous URL
    });

    final url = await CloudinaryService.uploadImage(file);

    setState(() {
      _imageUrl = url;
      _isUploading = false;
    });

    print("Uploaded URL: $url");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Upload"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: pickAndUpload,
                child: const Text("Pick & Upload Image"),
              ),

              const SizedBox(height: 20),

              if (_image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_image!, height: 150),
                ),

              const SizedBox(height: 20),

              if (_isUploading)
                const CircularProgressIndicator(),

              if (_imageUrl != null) ...[
                const SizedBox(height: 20),
                const Text(
                  "Uploaded Successfully ✅",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _imageUrl!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}