import 'package:tutor_app/features/courses/data/models/course_upload_progress.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart'; 
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/course_options.dart';
import 'package:tutor_app/features/courses/domain/entities/lecture_entity.dart';

class AddCourseState {

  final CourseEntity? editingCourse;
  final List<LectureEntity>? existingLectures;
  

  final bool? isEditing;

  final bool? isOptionsLoading;
  final String? optionsError;

  final CourseOptionsEntity? options;
  // Basic info
  final String title;
  final CategoryEntity? category;
  final String? language;
  final String? level;
  final bool isPaid;
  final String? price;
  final int? offer;
  final String? categoryName;
  
  // Error states for basic info
  final String? titleError;
  final String? categoryError;
  final String? languageError;
  final String? levelError;
  final String? priceError;
  final String? offerError;
   
  // Advanced info
  final String description;
  final String thumbnailPath;
  final String? descriptionError;
  final String? thumbnailError;
  
  // Curriculum
  final List<LectureCreationReq> lessons;
  final String currentLessonTitle;
  
  // Add lecture page fields
  final String? selectedVideoPath;
  final String? selectedPdfPath;
  final int? editingLectureIndex;
  final Duration? courseDuration;

  const AddCourseState({

    this.editingCourse,
    this.existingLectures,
    this.isEditing,

    this.options,

    this.isOptionsLoading,
    this.optionsError,
    // Basic info
    this.title = '',
    this.category,
    this.language,
    this.level,
    this.isPaid = false,
    this.price ='',
    this.offer,
    this.categoryName,
    
    // Error states
    this.titleError,
    this.categoryError,
    this.languageError,
    this.levelError,
    this.priceError,
    this.offerError,
    
    // Advanced info
    this.description = '',
    this.thumbnailPath = '',
    this.descriptionError,
    this.thumbnailError,
    
    // Curriculum
    this.courseDuration,
    this.lessons = const [
      
    ],
    this.currentLessonTitle = '',
    
    // Add lecture page fields
    this.selectedVideoPath,
    this.selectedPdfPath,
    this.editingLectureIndex

  });



  AddCourseState copyWith({

    CourseEntity? editingCourse,
    List<LectureEntity>? existingLectures,

   bool? isEditing, 
  CourseOptionsEntity? options,
  bool? isOptionsLoading,
  String? optionsError,
  Duration? courseDuration,

  String? title,
  CategoryEntity? category,
  String? language,
  String? level,
  bool? isPaid,
  String? price,
  int?offer,
  String? categoryName,

  String? titleError,
  String? categoryError,
  String? languageError,
  String? levelError,
  String? priceError,
  String? offerError,

  String? description,
  String? thumbnailPath,
  String? descriptionError,
  String? thumbnailError,

  List<LectureCreationReq>? lessons,
  String? currentLessonTitle,

  Object? selectedVideoPath = _noChange,
  Object? selectedPdfPath = _noChange,
  int? editingLectureIndex,
}) {
  return AddCourseState(

    editingCourse: editingCourse ?? this.editingCourse,
    existingLectures: existingLectures ?? this.existingLectures,

    isEditing: isEditing?? this.isEditing,
    options: options ?? this.options,
    isOptionsLoading: isOptionsLoading ?? this.isOptionsLoading,
    optionsError: optionsError ?? this.optionsError,

    title: title ?? this.title,
    category: category ?? this.category,
    language: language ?? this.language,
    level: level ?? this.level,
    isPaid: isPaid ?? this.isPaid,
    price: price ?? this.price,
    offer: offer?? this.offer,
    categoryName: categoryName ?? this.categoryName,

    titleError: titleError ?? this.titleError,
    categoryError: categoryError ?? this.categoryError,
    languageError: languageError ?? this.languageError,
    levelError: levelError ?? this.levelError,
    priceError: priceError ?? this.priceError,
    courseDuration: courseDuration ?? this.courseDuration,

    description: description ?? this.description,
    thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    descriptionError: descriptionError ?? this.descriptionError,
    thumbnailError: thumbnailError ?? this.thumbnailError,
    offerError: offerError?? this.offerError,

    lessons: lessons ?? this.lessons,
    currentLessonTitle: currentLessonTitle ?? this.currentLessonTitle,

    selectedVideoPath: selectedVideoPath == _noChange
        ? this.selectedVideoPath
        : selectedVideoPath as String?,
    selectedPdfPath: selectedPdfPath == _noChange
        ? this.selectedPdfPath
        : selectedPdfPath as String?,
    editingLectureIndex: editingLectureIndex ?? this.editingLectureIndex,
  );
}

static const _noChange = Object();


}


class CourseUploadState extends AddCourseState{}

class CourseUploadLoading extends CourseUploadState{
  UploadProgress progress;
  String message;
  CourseUploadLoading({required this.progress,required this.message});
}
class CourseUploadErrorState extends CourseUploadState{
  String error;
  CourseUploadErrorState({required this.error});
}

class CourseUploadSuccessStaete extends CourseUploadState{
  final CourseEntity course;
   CourseUploadSuccessStaete({required this.course});
}
