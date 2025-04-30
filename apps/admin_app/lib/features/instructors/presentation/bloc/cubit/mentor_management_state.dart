


import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:flutter/material.dart';

@immutable
sealed class MentorManagementState {
  final List<MentorEntity> mentors;
  final String? message;
  const MentorManagementState({this.message, required this.mentors});
}

// Keep mentors even when showing loading or error
final class MentorsLoading extends MentorManagementState {
  const MentorsLoading({required super.mentors});
}

final class MentorsLoadingSucces extends MentorManagementState {
  const MentorsLoadingSucces({required super.mentors});
}

final class MentorsLoadingError extends MentorManagementState {
  const MentorsLoadingError({required super.mentors});
}

final class MentorsUpdationLoading extends MentorManagementState {
  const MentorsUpdationLoading({required super.mentors});
}

final class MentorsUpdationSuccess extends MentorManagementState {
  const MentorsUpdationSuccess({required super.mentors});
}

final class MentorsUpdationError extends MentorManagementState {
  const MentorsUpdationError({required super.mentors});
}
