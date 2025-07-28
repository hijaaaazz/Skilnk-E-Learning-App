// Place this in lib/utils/io_stub.dart
class File {
  File(String path);
  bool existsSync() => false;
}
