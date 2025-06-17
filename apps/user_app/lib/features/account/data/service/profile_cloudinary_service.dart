import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';


abstract class ProfileCloudinaryService {
  Future<Either<String, String>> uploadImage(String path);
}

class ProfileCloudinaryServiceImp extends ProfileCloudinaryService {
  @override
  Future<Either<String, String>> uploadImage(String path) async {
    try {
      final file = File(path);

      if (!file.existsSync()) return Left("File does not exist");

      final mimeType = lookupMimeType(file.path);
      if (mimeType == null || !mimeType.startsWith("image/")) {
        return Left("Only image files are allowed");
      }

      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
      final uploadPreset = "preset-for-file-upload";

      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      final request = http.MultipartRequest("POST", uri);
      final fileBytes = await file.readAsBytes();
      final publicId = "profile_pics/${DateTime.now().millisecondsSinceEpoch}";

      final multipartFile = http.MultipartFile.fromBytes(
        "file",
        fileBytes,
        filename: publicId,
      );

      request.files.add(multipartFile);
      request.fields["upload_preset"] = uploadPreset;

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
      return Left("Upload error: $e");
    }
  }
}
