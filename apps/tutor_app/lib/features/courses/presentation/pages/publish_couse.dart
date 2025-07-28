import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/common/widgets/blurred_loading.dart';
import 'package:tutor_app/common/widgets/snack_bar.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';
import 'package:tutor_app/features/courses/presentation/widgets/adding_course_loading.dart';
import 'package:tutor_app/features/courses/presentation/widgets/lectur_card.dart';
import 'package:tutor_app/features/courses/presentation/widgets/property_preview.dart';
import 'package:tutor_app/features/courses/presentation/widgets/section_tile.dart';
import 'package:tutor_app/features/courses/presentation/widgets/step_page.dart';
import 'dart:convert' show base64Decode;

import 'package:tutor_app/features/courses/presentation/widgets/utils.dart';

class StepPublish extends StatelessWidget {
  const StepPublish({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCourseCubit, AddCourseState>(
      builder: (context, state) {
        return Stack(
          children: [
            CourseStepPage(
              icon: Icons.publish_rounded,
              title: "Publish",
              bodyContent: const PublishBody(),
              backtext: "Previous",
              onNext: () {
                final tutorId = context.read<AuthBloc>().state.user?.tutorId;

                if (tutorId == null) {
                  showAppSnackbar(context, "User not authenticated");
                  return;
                }

                final cubit = context.read<AddCourseCubit>();

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return BlocProvider.value(
                      value: cubit,
                      child: const UploadStatusDialog(),
                    );
                  },
                );
                if(state.isEditing ?? false){
                  cubit.uploadEditedCourse(context);
                }
                cubit.uploadCourse(tutorId, context);
              },
            ),
            if (state is CourseUploadLoading) const BlurredLoading(),
          ],
        );
      },
    );
  }
}

class PublishBody extends StatelessWidget {
  const PublishBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<AddCourseCubit, AddCourseState>(
        listener: (context, state) {
          if (state is CourseUploadSuccessStaete) {
            showAppSnackbar(context, "Course Upload Successful");
            context.goNamed(AppRouteConstants.exploreRouteName);
          }
          if (state is CourseUploadErrorState) {
            log(state.error);
            context.goNamed(AppRouteConstants.exploreRouteName);
            showAppSnackbar(context, "Course Upload Failed, Try Again ${state.error}");
          }
        },
        builder: (context, courseState) {
          log("Building PublishBody: thumbnailPath=${courseState.thumbnailPath}, hasThumbnailBytes=${courseState.thumbnailBytes != null}");
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const SectionTitle(title: 'Course Preview'),
                const SizedBox(height: 24),
                // Thumbnail
                const SectionTitle(title: 'Course Thumbnail'),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE8EAEF)),
                  ),
                  child: courseState.thumbnailPath.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildThumbnailWidget(courseState),
                        )
                      : const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 64,
                            color: Color(0xFF8C93A3),
                          ),
                        ),
                ),
                const SizedBox(height: 24),
                // Title
                PropertyPreview(
                  label: 'Title',
                  value: courseState.title.isNotEmpty
                      ? courseState.title
                      : 'Untitled Course',
                ),
                const SizedBox(height: 16),
                // Description
                PropertyPreview(
                  label: 'Description',
                  value: courseState.description.isNotEmpty
                      ? courseState.description
                      : 'No description provided',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                // Category & Language
                Row(
                  children: [
                    Expanded(
                      child: PropertyPreview(
                        label: 'Category',
                        value: courseState.category?.title ?? 'Uncategorized',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PropertyPreview(
                        label: 'Language',
                        value: courseState.language ?? 'Not specified',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Level & Pricing Info
                Row(
                  children: [
                    Expanded(
                      child: PropertyPreview(
                        label: 'Level',
                        value: courseState.level ?? 'Not specified',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PropertyPreview(
                        label: 'Price',
                        value: courseState.isPaid && courseState.price != null
                            ? courseState.price!
                            : 'Free',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Duration
                Row(
                  children: [
                    Expanded(
                      child: PropertyPreview(
                        label: 'Duration',
                        value: courseState.courseDuration != null
                            ? formatDuration(courseState.courseDuration!)
                            : 'Not specified',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Lectures
                SectionTitle(title: 'Lectures (${courseState.lessons.length})'),
                const SizedBox(height: 8),
                ...courseState.lessons.asMap().entries.map((entry) {
                  final index = entry.key;
                  final lecture = entry.value;
                  return LectureCard(index: index + 1, lecture: lecture);
                }),
                if (courseState.lessons.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE8EAEF)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'No lectures added',
                        style: TextStyle(
                          color: Color(0xFF8C93A3),
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumbnailWidget(AddCourseState courseState) {
    if (kIsWeb) {
      // Web: Use thumbnailBytes if available, or decode Base64 from thumbnailPath
      if (courseState.thumbnailBytes != null) {
        log("Displaying thumbnail with bytes");
        return Image.memory(
          courseState.thumbnailBytes!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            log("Error displaying thumbnail bytes: $error");
            return const Icon(
              Icons.image_outlined,
              size: 64,
              color: Color(0xFF8C93A3),
            );
          },
        );
      } else if (courseState.thumbnailPath.startsWith('data:image/') &&
          courseState.thumbnailPath.contains(';base64,')) {
        try {
          final base64String =
              courseState.thumbnailPath.split(',').last;
          final bytes = base64Decode(base64String);
          log("Displaying thumbnail from Base64 path");
          return Image.memory(
            bytes,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              log("Error decoding Base64 thumbnail: $error");
              return const Icon(
                Icons.image_outlined,
                size: 64,
                color: Color(0xFF8C93A3),
              );
            },
          );
        } catch (e) {
          log("Error parsing Base64 thumbnail: $e");
          return const Icon(
            Icons.image_outlined,
            size: 64,
            color: Color(0xFF8C93A3),
          );
        }
      }
    }
    // Non-web: Use network URL or file
    if (courseState.thumbnailPath.startsWith('http')) {
      log("Displaying thumbnail from network: ${courseState.thumbnailPath}");
      return Image.network(
        courseState.thumbnailPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          log("Error loading network thumbnail: $error");
          return const Icon(
            Icons.image_outlined,
            size: 64,
            color: Color(0xFF8C93A3),
          );
        },
      );
    }
    // Mobile: Use file
    log("Displaying thumbnail from file: ${courseState.thumbnailPath}");
    return Image.file(
      File(courseState.thumbnailPath),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        log("Error loading file thumbnail: $error");
        return const Icon(
          Icons.image_outlined,
          size: 64,
          color: Color(0xFF8C93A3),
        );
      },
    );
  }
}