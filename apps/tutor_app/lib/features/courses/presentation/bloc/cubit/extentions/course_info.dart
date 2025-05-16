import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_app/core/utils/image_cropper.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';

mixin CourseInfoHandlers on Cubit<AddCourseState> {
  void updateTitle(String title) {
    emit(state.copyWith(
      title: title,
      titleError: _validateTitle(title),
    ));
  }

  void updateIsPaid(bool isPaid) {
    emit(state.copyWith(isPaid: isPaid));
  }

  void updatePrice(String price) {

  emit(state.copyWith(
    price: price,
    priceError: _validatePrice(price),
  ));
}

void updateDiscount(String offer) {
  final parsedPrice = int.tryParse(offer);

  emit(state.copyWith(
    offer: parsedPrice,
    offerError: _validateDiscount(offer),
  ));
}


  void updateCategory(CategoryEntity? category) {
    emit(state.copyWith(
      category: category,
      categoryError: _validateCategory(category),
    ));
  }

  void updateLanguage(String? language) {
    emit(state.copyWith(
      language: language,
      languageError: language == null || language.isEmpty ? "Please select a language" : null,
    ));
  }

  void updateLevel(String? level) {
    emit(state.copyWith(
      level: level,
      levelError: level == null || level.isEmpty ? "Please select a level" : null,
    ));
  }

  void updateDescription(String description) {
    emit(state.copyWith(
      description: description,
      descriptionError: description.isEmpty ? "Description is required" : null,
    ));
  }

  Future<void> pickThumbnail() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        try {
          final croppedFile = await croppedImage(pickedFile);
          if (croppedFile != null) {
            updateThumbnailPath(croppedFile.path);
          }
        } catch (cropError) {
          log("Error cropping image: $cropError");
          updateThumbnailPath(pickedFile.path);
        }
      }
    } catch (e) {
      log("Error picking thumbnail: $e");
    }
  }

  void updateThumbnailPath(String path) {
    try {
      final file = File(path);
      if (!file.existsSync()) {
        log("Warning: Thumbnail file does not exist: $path");
      }
      emit(state.copyWith(thumbnailPath: path));
    } catch (e) {
      log("Error updating thumbnail path: $e");
    }
  }

  String? _validateTitle(String title) {
    if (title.isEmpty) {
      return "Title is required";
    } else if (title.length < 5) {
      return "Title must be at least 5 characters";
    }
    return '';
  }

  String? _validateDiscount(String discount) {
  if (!state.isPaid) return "";

  if (discount.isEmpty) return ''; // Will be treated as 0 later

  final offer = int.tryParse(discount);
  if (offer == null) return "Invalid number";

  if (offer < 0 || offer > 100) {
    return "Discount must be between 0 and 100";
  }

  return '';
}

  String? _validateCategory(CategoryEntity? category) {
    return category == null ? "Please select a category" : null;
  }

  String? _validatePrice(String price) {
    if (state.isPaid) {
      if (price.isEmpty) {
        return 'Price is required for paid courses';
      }
      final parsedPrice = int.tryParse(price);
      if (parsedPrice == null) {
        return 'Invalid price format';
      }
      if (parsedPrice <= 1) {
        return 'Price must be more than 1';
      }
    }
    return null;
  }

  void courseToEditLoad(CourseEntity courseToEdit) {
    log(courseToEdit.offerPercentage.toString());
  emit(state.copyWith(
    title: courseToEdit.title,
    description: courseToEdit.description,
    price: courseToEdit.price.toString(),
    offer: courseToEdit.offerPercentage,
    isPaid: courseToEdit.price > 0,
    
    
    categoryName: courseToEdit.categoryName,
    courseDuration: Duration(seconds: courseToEdit.duration),
    level: courseToEdit.level,
    thumbnailPath: courseToEdit.courseThumbnail,
    lessons: courseToEdit.lessons.map((e) {
      return LectureCreationReq(
        title: e.title,
        videoUrl: e.videoUrl,
        notesUrl: e.notesUrl,
        duration: e.duration,
      );
    }).toList(),
    // You'll need to convert `categoryId` to a `CategoryEntity` if necessary.
    // For now, setting category as `null` until mapping is available.
    category: null,
    language: courseToEdit.language, // Only set if you have this info from somewhere
    isEditing: true,
    editingCourse: courseToEdit
  ));
}

}