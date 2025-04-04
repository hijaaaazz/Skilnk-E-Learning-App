


import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:flutter/material.dart';


@immutable
sealed class MentorManagementState {}


final class MentorsLoading extends MentorManagementState {}


final class MentorsLoadingSucces extends MentorManagementState {
  final List<MentorEntity> mentors;

  MentorsLoadingSucces({required this.mentors,});
  
}

final class MentorsLoadingError extends MentorManagementState {}



