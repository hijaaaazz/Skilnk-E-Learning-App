import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
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
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          final base64Image = "data:image/png;base64,${base64Encode(bytes)}";
          updateThumbnailPath(base64Image);
        } else {
          try {
            final croppedFile = await croppedImage(pickedFile);
            updateThumbnailPath(croppedFile?.path ?? pickedFile.path);
          } catch (cropError) {
            log("Error cropping image: $cropError");
            updateThumbnailPath(pickedFile.path);
          }
        }
      }
    } catch (e) {
      log("Error picking thumbnail: $e");
    }
  }

  void updateThumbnailPath(String path) {
    try {
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
    return null;
  }

  String? _validateDiscount(String discount) {
    if (!state.isPaid) return null;
    if (discount.isEmpty) return null;
    final offer = int.tryParse(discount);
    if (offer == null) return "Invalid number";
    if (offer < 0 || offer > 100) {
      return "Discount must be between 0 and 100";
    }
    return null;
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
    log('Loading course to edit: ${courseToEdit.title}, offer: ${courseToEdit.offerPercentage}');
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
      category: null,
      language: courseToEdit.language,
      isEditing: true,
      editingCourse: courseToEdit,
    ));

    log("edit started");
  }
}