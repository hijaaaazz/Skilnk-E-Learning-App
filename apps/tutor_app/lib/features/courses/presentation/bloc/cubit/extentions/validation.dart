import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/common/widgets/snack_bar.dart';
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';

/// A mixin that handles all validation for course creation
mixin ValidationHandlers on Cubit<AddCourseState> {
  /// Helper function to check if a path is a network URL
  bool _isNetworkUrl(String? path) {
  if (path == null || path.trim().isEmpty) return false;
  final cleaned = path.trim();
  log("Checking path: '$cleaned'");
  return cleaned.startsWith('http://') || cleaned.startsWith('https://');
}


  /// Clears all validation errors
  void clearValidationErrors() {
    emit(state.copyWith(
      titleError: null,
      categoryError: null,
      languageError: null,
      levelError: null,
      descriptionError: null,
      thumbnailError: null,
      priceError: null,
      offerError: null,
    ));
  }

  /// Validates title input
  String? validateTitle(String title) {
    if (title.isEmpty) {
      return "Title is required";
    } else if (title.length < 5) {
      return "Title must be at least 5 characters";
    }
    return null;
  }

  /// Validates category selection
  String? validateCategory(CategoryEntity? category) {
    return category == null ? "Please select a category" : null;
  }

  /// Validates language selection
  String? validateLanguage(String? language) {
    return language == null || language.isEmpty 
        ? "Please select a language" 
        : null;
  }

  /// Validates level selection
  String? validateLevel(String? level) {
    return level == null || level.isEmpty 
        ? "Please select a level" 
        : null;
  }

  /// Validates price for paid courses
  String? validatePrice(String price) {
    if (!state.isPaid) return null;
    
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
    
    return null;
  }
  
  /// Validates discount percentage
  String? validateDiscount(String discount) {
    if (!state.isPaid) return null;

    // Allow empty discount (will be treated as 0)
    if (discount.isEmpty) return null;

    final offer = int.tryParse(discount);
    if (offer == null) return "Invalid number";

    if (offer < 0 || offer > 100) {
      return "Discount must be between 0 and 100";
    }

    return null;
  }

  /// Validates course description
  String? validateDescription(String description) {
    return description.trim().isEmpty 
        ? "Description is required" 
        : null;
  }

  /// Validates thumbnail selection with URL support
  String? validateThumbnail(String thumbnailPath) {
    // In edit mode, if it's a network URL, consider it valid
    if (state.isEditing == true && _isNetworkUrl(thumbnailPath)) {
      return "";
    }
    
    if (thumbnailPath.isEmpty) {
      return "Please select a thumbnail";
    }
    
    try {
      final file = File(thumbnailPath);
      if (!file.existsSync()) {
        log("${file.path} ${state.isEditing}");
        return "Thumbnail file not found";
      }
    } catch (e) {
      log("Error validating thumbnail: $e");
      return "Invalid thumbnail path";
    }
    
    return "";
  }

  /// Validates the basic course information
  bool validateBasicInfo() {
    try {
      final titleError = validateTitle(state.title);
      final categoryError = validateCategory(state.category);
      final languageError = validateLanguage(state.language);
      final levelError = validateLevel(state.level);
      final priceError = validatePrice(state.price.toString());
      final discountError = validateDiscount(state.offer?.toString() ?? "");

      emit(state.copyWith(
        titleError: titleError,
        categoryError: categoryError,
        languageError: languageError,
        levelError: levelError,
        priceError: priceError,
        offerError: discountError,
      ));

      return titleError == null && 
             categoryError == null && 
             languageError == null && 
             levelError == null && 
             priceError == null && 
             discountError == null;
    } catch (e, stack) {
      log("Error validating basic info: $e\n$stack");
      return false;
    }
  }

  /// Validates advanced course information including thumbnail and description
  bool validateAdvancedInfo(BuildContext context) {
    try {
      final thumbnailError = validateThumbnail(state.thumbnailPath);
      final descriptionError = validateDescription(state.description);

      emit(state.copyWith(
        thumbnailError: thumbnailError,
        descriptionError: descriptionError,
      ));

      if (thumbnailError != null && thumbnailError.isNotEmpty) {
        showAppSnackbar(context, thumbnailError);
        return false;
      }

      if (descriptionError != null && descriptionError.isNotEmpty) {
        showAppSnackbar(context, descriptionError);
        return false;
      }

      return true;
    } catch (e) {
      log("Error validating advanced info: $e");
      showAppSnackbar(context, "An error occurred during validation");
      return false;
    }
  }

  /// Validates course curriculum (lectures) - with URL support for edit mode
  bool validateCurriculum(BuildContext context) {
    try {
      log(state.lessons.map((e)=> e.notesUrl).toList().toString());
      log(state.lessons.map((e)=> e.videoUrl).toList().toString());
      if (state.lessons.isEmpty) {
        showAppSnackbar(context, "Please add at least one lecture to your course");
        return false;
      }
      
      for (int i = 0; i < state.lessons.length; i++) {
        final lecture = state.lessons[i];
        
        // Check if video exists
        if (lecture.videoUrl == null || lecture.videoUrl!.isEmpty) {
          showAppSnackbar(context, "Lecture '${lecture.title}' has no video. Please add it again.");
          return false;
        }
        
        // If in edit mode and it's a network URL, consider it valid
        if (state.isEditing == true && _isNetworkUrl(lecture.videoUrl)) {
          // Skip file existence check for network URLs
          continue;
        }
        
        // Validate video file exists for local files
        final videoFile = File(lecture.videoUrl!);
        if (!videoFile.existsSync()) {
          showAppSnackbar(context, "Video for lecture '${lecture.title}' not found. Please add it again.");
          return false;
        }
        
        // Validate PDF notes if provided
        if (lecture.notesUrl != null && lecture.notesUrl!.isNotEmpty) {
          // If in edit mode and it's a network URL, consider it valid
          if (state.isEditing == true && _isNetworkUrl(lecture.notesUrl)) {
            continue;
          }
          
          final pdfFile = File(lecture.notesUrl!);
          if (!pdfFile.existsSync()) {
            showAppSnackbar(context, "PDF notes for lecture '${lecture.title}' not found.");
            // We don't return false here as missing notes shouldn't block submission
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
}