import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/env.dart';

abstract class ProfileCloudinaryService {
  Future<Either<String, String>> uploadImage(XFile file);
}

class ProfileCloudinaryServiceImp extends ProfileCloudinaryService {
  @override
  Future<Either<String, String>> uploadImage(XFile file) async {
    try {
      // Read file bytes
      final fileBytes = await file.readAsBytes();
      if (fileBytes.isEmpty) {
        return Left("File is empty");
      }

      // Determine MIME type
      final mimeType = lookupMimeType(file.name) ?? 'image/jpeg';
      if (!mimeType.startsWith('image/')) {
        return Left("Only image files are allowed");
      }

      // Get Cloudinary credentials
      final cloudName = kIsWeb
          ? Env.cloudinaryCloudName
          : dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
      if (cloudName.isEmpty) {
        return Left("Cloudinary cloud name not configured");
      }

      final uploadPreset = "preset-for-file-upload";
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      // Create multipart request
      final request = http.MultipartRequest("POST", uri);
      final publicId = "profile_pics/${DateTime.now().millisecondsSinceEpoch}";

      final multipartFile = http.MultipartFile.fromBytes(
        "file",
        fileBytes,
        filename: file.name.isNotEmpty ? file.name : publicId,
        // Removed contentType
      );

      request.files.add(multipartFile);
      request.fields["upload_preset"] = uploadPreset;

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      log("Cloudinary Response: $responseBody");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        final fileUrl = decoded["secure_url"];
        return Right(fileUrl);
      } else {
        return Left("Cloudinary upload failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("Upload error: $e");
      return Left("Upload error: $e");
    }
  }
}