import 'dart:io';
import 'dart:developer';
import 'package:video_player/video_player.dart';

Future<Duration?> getVideoDuration(String videoPath) async {
  try {
    // Ensure this code runs only on Android
    if (!Platform.isAndroid) {
      log("This function is intended only for Android.");
      return null;
    }

    final file = File(videoPath);
    if (!file.existsSync()) {
      log("Error: Video file does not exist: $videoPath");
      return null;
    }

    final controller = VideoPlayerController.file(file);
    await controller.initialize();
    final duration = controller.value.duration;
    await controller.dispose();

    log("Android video duration: $duration");
    return duration;
  } catch (e) {
    log("Error getting video duration on Android: $e");
    return null;
  }
}
