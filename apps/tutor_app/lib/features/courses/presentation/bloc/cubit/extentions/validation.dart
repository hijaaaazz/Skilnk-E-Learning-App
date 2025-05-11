import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/common/widgets/snack_bar.dart';
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';

mixin ValidationHandlers on Cubit<AddCourseState> {
  void clearValidationErrors() {
    log("Not working");
    emit(state.copyWith(
      titleError: "",
      categoryError: "",
      languageError: "",
      levelError: '',
      descriptionError: "",
      thumbnailError: '',
      priceError: ""
    ));
  }

  bool validateBasicInfo() {
  try {
    final titleError = _validateTitle(state.title);
    final categoryError = _validateCategory(state.category);
    final discountError = _validateDiscount(state.offer.toString());
    final priceError = state.isPaid ? _validatePrice(state.price.toString()) : null;
    final languageError = state.language == null || state.language!.isEmpty
        ? "Please select a language"
        : null;
    final levelError = state.level == null || state.level!.isEmpty
        ? "Please select a level"
        : null;


    emit(state.copyWith(
      titleError: titleError,
      categoryError: categoryError,
      priceError: priceError,
      languageError: languageError,
      levelError: levelError,
    ));

    return (titleError == null || titleError.isEmpty) &&
       (categoryError == null || categoryError.isEmpty) &&
       (priceError == null || priceError.isEmpty) &&
       (languageError == null || languageError.isEmpty) &&
       (discountError == null || discountError.isEmpty) &&
       (levelError == null || levelError.isEmpty);

  } catch (e, stack) {
    log("Error validating basic info: $e\n$stack");
    return false;
  }
}


  bool validateAdvancedInfo(BuildContext context) {
    try {
      bool isValid = true;
      if (state.thumbnailPath.isEmpty) {
        showAppSnackbar(context, "Please select a thumbnail");
        emit(state.copyWith(thumbnailError: "Please select a thumbnail"));
        isValid = false;
      } else {
        final file = File(state.thumbnailPath);
        if (!file.existsSync()) {
          showAppSnackbar(context, "Thumbnail file not found. Please select again.");
          emit(state.copyWith(thumbnailError: "Thumbnail file not found"));
          isValid = false;
        } else {
          emit(state.copyWith(thumbnailError: null));
        }
      }
      if (state.description.trim().isEmpty) {
        emit(state.copyWith(descriptionError: "Description is required"));
        isValid = false;
      } else {
        emit(state.copyWith(descriptionError: ""));
      }
      return isValid;
    } catch (e) {
      log("Error validating advanced info: $e");
      showAppSnackbar(context, "An error occurred during validation");
      return false;
    }
  }

  bool validateCurriculum(BuildContext context) {
    try {
      if (state.lessons.isEmpty) {
        showAppSnackbar(context, "Please add at least one lecture to your course");
        return false;
      }
      for (int i = 0; i < state.lessons.length; i++) {
        final lecture = state.lessons[i];
        if (lecture.videoUrl == null || lecture.videoUrl!.isEmpty) {
          showAppSnackbar(context, "Lecture '${lecture.title}' has no video. Please add it again.");
          return false;
        }
        final videoFile = File(lecture.videoUrl!);
        if (!videoFile.existsSync()) {
          showAppSnackbar(context, "Video for lecture '${lecture.title}' not found. Please add it again.");
          return false;
        }
        if (lecture.notesUrl != null && lecture.notesUrl!.isNotEmpty) {
          final pdfFile = File(lecture.notesUrl!);
          if (!pdfFile.existsSync()) {
            showAppSnackbar(context, "PDF notes for lecture '${lecture.title}' not found.");
          }
        }
      }
      return true;
    } catch (e) {
      log("Error validating curriculum: $e");
      showAppSnackbar(context, "An error occurred while checking your lectures");
      return false;
    }
  }
  String? _validateTitle(String title) {
    if (title.isEmpty) {
      return "Title is required";
    } else if (title.length < 5) {
      return "Title must be at least 5 characters";
    } else {
      return "";
    }
  }




  String? _validateCategory(CategoryEntity? category) {
    return category == null ? "Please select a category" : "";
  }

  String _validatePrice(String price) {
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

    


    return ""; 
  }
  
  String? _validateDiscount(String discount) {
  if (!state.isPaid) return "";

  if (discount.isEmpty) return ""; // Will be treated as 0 later

  final offer = int.tryParse(discount);
  if (offer == null) return "Invalid number";

  if (offer < 0 || offer > 100) {
    return "Discount must be between 0 and 100";
  }

  return "";
}
}

