import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/common/widgets/snack_bar.dart';
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';

mixin ValidationHandlers on Cubit<AddCourseState> {
  bool validateBasicInfo(BuildContext context) {
    // ... (Your provided validateBasicInfo is correct and unchanged)
    try {
      log("Validating basic info: title=${state.title}, category=${state.category?.title}, "
          "language=${state.language}, level=${state.level}, isPaid=${state.isPaid}, "
          "price=${state.price}, offer=${state.offer}");

      final titleError = validateTitle(state.title);
      final categoryError = validateCategory(state.category);
      final languageError = validateLanguage(state.language);
      final levelError = validateLevel(state.level);
      final priceError = state.isPaid ? validatePrice(state.price ?? '') : null;
      final discountError = state.isPaid ? validateDiscount(state.offer?.toString() ?? '') : null;

      emit(state.copyWith(
        titleError: titleError,
        categoryError: categoryError,
        languageError: languageError,
        levelError: levelError,
        priceError: priceError,
        offerError: discountError,
      ));

      if (titleError != null) {
        log("Title validation error: $titleError");
        showAppSnackbar(context, titleError);
      } else if (categoryError != null) {
        log("Category validation error: $categoryError");
        showAppSnackbar(context, categoryError);
      } else if (languageError != null) {
        log("Language validation error: $languageError");
        showAppSnackbar(context, languageError);
      } else if (levelError != null) {
        log("Level validation error: $levelError");
        showAppSnackbar(context, levelError);
      } else if (priceError != null) {
        log("Price validation error: $priceError");
        showAppSnackbar(context, priceError);
      } else if (discountError != null) {
        log("Discount validation error: $discountError");
        showAppSnackbar(context, discountError);
      }

      final isValid = titleError == null &&
          categoryError == null &&
          languageError == null &&
          levelError == null &&
          priceError == null &&
          discountError == null;

      log("Basic info validation result: $isValid");
      return isValid;
    } catch (e, stack) {
      log("Error validating basic info: $e\n$stack");
      showAppSnackbar(context, "Validation error: $e");
      return false;
    }
  }

  String? validateTitle(String? title) {
    if (title == null || title.isEmpty) {
      return "Please enter a course title";
    }
    if (title.length < 3) {
      return "Title must be at least 3 characters long";
    }
    if (title.length > 100) {
      return "Title must be less than 100 characters";
    }
    return null;
  }

  String? validateCategory(CategoryEntity? category) {
    if (category == null || category.id.isEmpty) {
      return "Please select a category";
    }
    return null;
  }

  String? validateLanguage(String? language) {
    if (language == null || language.isEmpty) {
      return "Please select a language";
    }
    return null;
  }

  String? validateLevel(String? level) {
    if (level == null || level.isEmpty) {
      return "Please select a level";
    }
    return null;
  }

  String? validatePrice(String? price) {
    if (price == null || price.isEmpty) {
      return "Please enter a price";
    }
    final priceValue = double.tryParse(price);
    if (priceValue == null || priceValue <= 0) {
      return "Please enter a valid price";
    }
    return null;
  }

  String? validateDiscount(String? discount) {
    if (discount == null || discount.isEmpty) {
      return null; // Discount is optional
    }
    final discountValue = int.tryParse(discount);
    if (discountValue == null || discountValue < 0 || discountValue > 100) {
      return "Discount must be between 0 and 100";
    }
    return null;
  }

  bool validateAdvancedInfo(BuildContext context) {
    final descriptionError = validateDescription(state.description);
    final thumbnailError = validateThumbnail(state.thumbnailPath);

    emit(state.copyWith(
      descriptionError: descriptionError,
      thumbnailError: thumbnailError,
    ));

    if (descriptionError != null) {
      log("Description validation error: $descriptionError");
      showAppSnackbar(context, descriptionError);
    }
    if (thumbnailError != null) {
      log("Thumbnail validation error: $thumbnailError");
      showAppSnackbar(context, thumbnailError);
    }

    return descriptionError == null && thumbnailError == null;
  }

  String? validateDescription(String? description) {
    if (description == null || description.isEmpty) {
      return "Please enter a course description";
    }
    if (description.length < 10) {
      return "Description must be at least 10 characters long";
    }
    return null;
  }

  String? validateThumbnail(String thumbnailPath) {
    if (state.isEditing == true && _isNetworkUrl(thumbnailPath)) return null;
    if (kIsWeb) {
      if (thumbnailPath.isEmpty) return "Please select a thumbnail";
      if (!_isBase64Url(thumbnailPath)) return "Invalid thumbnail format";
      return null;
    }
    if (thumbnailPath.isEmpty) return "Please select a thumbnail";
    return null;
  }

  bool validateCurriculum(BuildContext context) {
    log("Validating curriculum: lessons count = ${state.lessons.length}, isEditing = ${state.isEditing}");
    
    if (state.lessons.isEmpty) {
      log("Validation failed: No lectures added");
      showAppSnackbar(context, "Please add at least one lecture to your course");
      return false;
    }

    for (var lecture in state.lessons) {
      if (lecture.title == null || lecture.title!.isEmpty) {
        log("Validation failed: Lecture has no title");
        showAppSnackbar(context, "Lecture has no title");
        return false;
      }
      if (lecture.videoUrl == null || lecture.videoUrl!.isEmpty) {
        log("Validation failed: Lecture '${lecture.title}' has no video URL");
        showAppSnackbar(context, "Lecture '${lecture.title}' has no video");
        return false;
      }
      if (kIsWeb) {
        // Allow network URLs during editing, Base64 for new courses
        if (state.isEditing == true && _isNetworkUrl(lecture.videoUrl)) {
          log("Valid network video URL for lecture '${lecture.title}': ${lecture.videoUrl}");
        } else if (!_isBase64Url(lecture.videoUrl)) {
          log("Invalid video format for lecture '${lecture.title}': ${lecture.videoUrl}");
          showAppSnackbar(context, "Lecture '${lecture.title}' has invalid video format");
          return false;
        }
        // Validate notesUrl if present
        if (lecture.notesUrl != null && lecture.notesUrl!.isNotEmpty) {
          if (state.isEditing == true && _isNetworkUrl(lecture.notesUrl)) {
            log("Valid network notes URL for lecture '${lecture.title}': ${lecture.notesUrl}");
          } else if (!_isBase64Url(lecture.notesUrl)) {
            log("Invalid notes format for lecture '${lecture.title}': ${lecture.notesUrl}");
            showAppSnackbar(context, "PDF notes for '${lecture.title}' have invalid format");
            // Warn but don't fail for notes
          }
        }
      } else {
        // Non-web: Ensure videoUrl is a valid file path
        if (!_isFilePath(lecture.videoUrl)) {
          log("Invalid video file path for lecture '${lecture.title}': ${lecture.videoUrl}");
          showAppSnackbar(context, "Lecture '${lecture.title}' has invalid video file path");
          return false;
        }
        if (lecture.notesUrl != null && lecture.notesUrl!.isNotEmpty && !_isFilePath(lecture.notesUrl)) {
          log("Invalid notes file path for lecture '${lecture.title}': ${lecture.notesUrl}");
          showAppSnackbar(context, "PDF notes for '${lecture.title}' have invalid file path");
          // Warn but don't fail
        }
      }
    }
    log("Curriculum validation passed");
    return true;
  }

  bool _isBase64Url(String? url) {
    if (url == null) return false;
    return url.startsWith('data:image/') || 
           url.startsWith('data:video/') || 
           url.startsWith('data:application/pdf');
  }

  bool _isNetworkUrl(String? url) {
    if (url == null) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  bool _isFilePath(String? path) {
    if (path == null || path.isEmpty) return false;
    return !path.startsWith('data:') && !path.startsWith('http');
  }
}