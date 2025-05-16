import 'dart:io';

import 'package:video_player/video_player.dart';

Future<Duration?> getVideoDuration(String videoPath) async {
  final VideoPlayerController controller = VideoPlayerController.file(File(videoPath));

  try {
    await controller.initialize(); // Load video info
    Duration duration = controller.value.duration;
    await controller.dispose(); // Clean up
    return duration;
  } catch (e) {
    return null;
  }
}
