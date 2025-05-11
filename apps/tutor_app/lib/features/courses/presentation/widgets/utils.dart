String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  List<String> parts = [];

  if (hours > 0) parts.add('$hours hour${hours > 1 ? 's' : ''}');
  if (minutes > 0) parts.add('$minutes minute${minutes > 1 ? 's' : ''}');
  if (seconds > 0 || parts.isEmpty) parts.add('$seconds second${seconds > 1 ? 's' : ''}');

  return parts.join(' ');
}

String getFileName(String path) {
  return path.split('/').last;
}