import 'package:image_picker/image_picker.dart';

class UpdateDpParams{
  final String userId;
  final XFile imagePath;

  UpdateDpParams({required this.imagePath,required this.userId});
}