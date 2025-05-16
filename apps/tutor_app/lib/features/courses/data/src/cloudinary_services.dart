
// FILE: cloudinary_services.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

abstract class CourseCloudinaryServices {
  Future<Either<String, String>> uploadFile(String path,String title,String id);
}

class CourseCloudinaryServiceImp extends CourseCloudinaryServices {
  @override
  Future<Either<String, String>> uploadFile(String path,String title,String id) async {
    try {
      final file = File(path);

      if (!file.existsSync()) return Left("File does not exist");

      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
      final uploadPreset = "preset-for-file-upload";

      final mimeType = lookupMimeType(file.path);
      if (mimeType == null) return Left("Could not determine file type");

      String resourceType;
      if (mimeType.startsWith("image/")) {
        resourceType = "image";
      } else if (mimeType.startsWith("video/")) {
        resourceType = "video";
      } else {
        resourceType = "raw"; // For PDFs, docs, etc.
      }

      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload");

      final request = http.MultipartRequest("POST", uri);
      final fileBytes = await file.readAsBytes();
      final publicId = "courses/$id/${DateTime.now().millisecondsSinceEpoch}_$title";


      final multipartFile = http.MultipartFile.fromBytes(
        "file",
        fileBytes,
        filename: publicId,
      );

      request.files.add(multipartFile);
      request.fields["upload_preset"] = uploadPreset;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      log("Status Code: ${response.statusCode}");
      log("Response Body: $responseBody");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        final fileUrl = decoded["secure_url"];
        return Right(fileUrl);
      } else {
        return Left("Failed to upload: ${response.reasonPhrase}");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }
}