import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/account/data/models/delete_category.dart';
import 'package:tutor_app/features/account/data/models/update_bio_params.dart';
import 'package:tutor_app/features/account/data/models/update_category_params.dart';
import 'package:tutor_app/features/account/data/models/update_dp_params.dart';
import 'package:tutor_app/features/account/data/models/update_name_params.dart';
import 'package:tutor_app/features/courses/data/models/category_model.dart';
abstract class ProfileRepository {
  Future<Either<String, String>> updateProfilePic(UpdateDpParams params);
  Future<Either<String, String>> updateName(UpdateNameParams params);
  Future<Either<String,List<String>>> addCategory(UpdateCategoryParams category);
  Future<Either<String,List<CategoryModel>>> getCategories();
  Future<Either<String,bool>> deleteCategory(DeleteCategoryParams params);
  Future<Either<String,String>> updateBio(UpdateBioParams params);


}