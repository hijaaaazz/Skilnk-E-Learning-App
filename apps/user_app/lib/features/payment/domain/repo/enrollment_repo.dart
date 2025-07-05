import 'package:dartz/dartz.dart';
import  'package:user_app/features/home/domain/entity/course-entity.dart';
import  'package:user_app/features/payment/data/models/add_purchase_params.dart';

abstract class EnrollmentRepository{
  Future<Either<String,CourseEntity>>enrollCourse(AddPurchaseParams params);
}