import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RaiseComplaintScreen extends StatefulWidget {
  const RaiseComplaintScreen({super.key});

  @override
  State<RaiseComplaintScreen> createState() => _RaiseComplaintScreenState();
}

class _RaiseComplaintScreenState extends State<RaiseComplaintScreen> {
  final TextEditingController _descController = TextEditingController();

  File? _image;
  String? _imageUrl;
  bool _isUploading = false;
  String? _selectedArea;

  Future<void> pickAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    setState(() {
      _image = file;
      _isUploading = true;
    });

    final url = await CloudinaryService.uploadImage(file);

    setState(() {
      _imageUrl = url;
      _isUploading = false;
    });
  }

  Future<void> submitComplaint() async {
    if (_imageUrl == null || _descController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Add image & description")));
      return;
    }

    await FirebaseFirestore.instance.collection('complaints').add({
      'description': _descController.text,
      'imageUrl': _imageUrl,
      'area': _selectedArea,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Complaint Submitted ✅")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Raise Complaint")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickAndUpload,
              child: const Text("Upload Image"),
            ),

            const SizedBox(height: 10),

            if (_image != null) Image.file(_image!, height: 120),

            if (_isUploading) const CircularProgressIndicator(),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedArea,
              hint: const Text("Select Area"),
              items: ["Andheri", "Bandra", "Dadar", "Powai", "Kurla"].map((
                area,
              ) {
                return DropdownMenuItem(value: area, child: Text(area));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedArea = value;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: submitComplaint,
              child: const Text("Submit Complaint"),
            ),
          ],
        ),
      ),
    );
  }
}
