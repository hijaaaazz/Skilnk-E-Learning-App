import 'package:tutor_app/features/courses/domain/entities/language_entity.dart';

class LanguageModel {
  final String language;
  
  final String flag;

  LanguageModel({
    required this.language,
    required this.flag,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
  return LanguageModel(
    language: json['language']?.toString() ?? '',
    flag: json['flag']?.toString() ?? '',
  );
}


   LanguageEntity toEntity() {
    return LanguageEntity(
      name: language,
      flag: flag,
    );
  }

 
}