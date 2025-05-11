import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

croppedImage(dynamic pickedFile){
    return  ImageCropper().cropImage(
  sourcePath: pickedFile.path,
  aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
  uiSettings: [
    AndroidUiSettings(
      toolbarTitle: 'Crop Thumbnail',
      showCropGrid: false,
      hideBottomControls: true,
      toolbarColor: const Color.fromARGB(255, 0, 0, 0),
      toolbarWidgetColor: Colors.white,
      
      initAspectRatio: CropAspectRatioPreset.ratio16x9,
      lockAspectRatio: true,
    ),
   
  ],
);
  }