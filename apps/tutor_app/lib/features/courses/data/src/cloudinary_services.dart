import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:tutor_app/env.dart';

abstract class CourseCloudinaryServices {
  Future<Either<String, String>> uploadFile(String path, String title, String id);
}

class CourseCloudinaryServiceImp extends CourseCloudinaryServices {
  @override
  Future<Either<String, String>> uploadFile(String path, String title, String id) async {
    try {
      List<int> fileBytes;
      String? mimeType;

      if (kIsWeb && path.startsWith('data:')) {
        // Web: Handle Base64 string
        log("Web: Processing Base64 file for upload: $path");
        try {
          final base64String = path.split(',').last;
          fileBytes = base64Decode(base64String);
          mimeType = path.split(';').first.split(':').last;
          log("Base64 decoded, bytes length: ${fileBytes.length}, mimeType: $mimeType");
        } catch (e) {
          log("Error decoding Base64: $e");
          return Left("Invalid Base64 data: $e");
        }
      } else if (!kIsWeb) {
        // Mobile: Handle file path
        final file = File(path);
        if (!file.existsSync()) {
          log("File does not exist: $path");
          return Left("File does not exist");
        }
        fileBytes = await file.readAsBytes();
        mimeType = lookupMimeType(file.path);
        log("Mobile file read, bytes length: ${fileBytes.length}, mimeType: $mimeType");
      } else {
        log("Invalid file path: $path");
        return Left("Invalid file path or format");
      }

      if (mimeType == null) {
        log("Could not determine MIME type for: $path");
        return Left("Could not determine file type");
      }

      String resourceType;
      if (mimeType.startsWith("image/")) {
        resourceType = "image";
      } else if (mimeType.startsWith("video/")) {
        resourceType = "video";
      } else if (mimeType.startsWith("application/pdf")) {
        resourceType = "raw";
      } else {
        log("Unsupported MIME type: $mimeType");
        return Left("Unsupported file type: $mimeType");
      }

      final cloudName = kIsWeb
          ? Env.cloudinaryCloudName
          : dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
      if (cloudName.isEmpty) {
        log("Cloudinary cloud name not configured");
        return Left("Cloudinary configuration missing");
      }

      final uploadPreset = "preset-for-file-upload";
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload");
      final publicId = "courses/$id/${DateTime.now().millisecondsSinceEpoch}_$title";

      final request = http.MultipartRequest("POST", uri);
      final multipartFile = http.MultipartFile.fromBytes(
        "file",
        fileBytes,
        filename: publicId,
      );

      request.files.add(multipartFile);
      request.fields["upload_preset"] = uploadPreset;
      request.fields["public_id"] = publicId;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      log("Cloudinary upload - Status: ${response.statusCode}, Body: $responseBody");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        final fileUrl = decoded["secure_url"] as String?;
        if (fileUrl == null) {
          log("Cloudinary response missing secure_url");
          return Left("Failed to retrieve file URL");
        }
        log("File uploaded successfully: $fileUrl");
        return Right(fileUrl);
      } else {
        log("Cloudinary upload failed: ${response.reasonPhrase}");
        return Left("Failed to upload: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("Error uploading to Cloudinary: $e");
      return Left("Error uploading file: $e");
    }
  }
}