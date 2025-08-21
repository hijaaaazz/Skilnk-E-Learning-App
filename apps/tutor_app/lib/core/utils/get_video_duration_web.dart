import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

Future<Duration?> getVideoDuration(String videoPath, {Uint8List? bytes}) async {
  try {
    if (kIsWeb && bytes != null) {
      // Web-specific handling using dart:html
      log("Getting video duration for web with Base64 data");
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final video = html.VideoElement()..src = url;
      
      // Wait for metadata to load
      await video.onLoadedMetadata.first;
      final duration = Duration(seconds: video.duration.round());
      
      // Clean up
      html.Url.revokeObjectUrl(url);
      video.remove();
      
      log("Web video duration: $duration");
      return duration;
    } else if (!kIsWeb) {
      // Mobile-specific handling using video_player
      log("Getting video duration for mobile: $videoPath");
      final file = File(videoPath);
      if (!file.existsSync()) {
        log("Error: Video file does not exist: $videoPath");
        return null;
      }
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      final duration = controller.value.duration;
      await controller.dispose();
      log("Mobile video duration: $duration");
      return duration;
    } else {
      log("Error: No valid video data provided for web (bytes are null)");
      return null;
    }
  } catch (e) {
    log("Error getting video duration: $e");
    return null;
  }
}