import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static Future<String?> uploadImage(XFile imageFile) async {
    final cloudName = 'dlsgmck6z';

    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'complaint_upload';

    if (kIsWeb) {
      final bytes = await imageFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: imageFile.name,
        ),
      );
    } else {
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final resData =
          json.decode(await response.stream.bytesToString());
      return resData['secure_url'];
    } else {
      print("Upload failed");
      return null;
    }
  }
}