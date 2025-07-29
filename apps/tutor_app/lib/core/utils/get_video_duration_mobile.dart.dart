import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';

Future<Duration?> getVideoDuration(String videoPath, {Uint8List? bytes}) async {
  try {
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
  } catch (e) {
    log("Error in mobile getVideoDuration: $e");
    return null;
  }
}
