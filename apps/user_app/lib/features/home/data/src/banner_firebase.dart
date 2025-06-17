import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/data/models/banner_model.dart';

abstract class BannerFirebaseService {
  Future<Either<String, List<BannerModel>>> getLatestBanners();
}

class BannerFirebaseServiceImp extends BannerFirebaseService {
  
  static const String _collectionName = 'banner';
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, List<BannerModel>>> getLatestBanners() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .limit(3)
          .get();

      final banners = querySnapshot.docs
          .map((doc) => BannerModel.fromJson(doc.data()))
          .toList();

      return Right(banners);
    } catch (e) {
      return Left("Failed to fetch banners: ${e.toString()}");
    }
  }
}
