import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import  'package:user_app/core/routes/app_route_constants.dart';
import  'package:user_app/features/explore/data/models/search_args.dart';
import  'package:user_app/features/explore/data/models/search_params_model.dart';
import  'package:user_app/features/home/domain/entity/category_entity.dart';

class CategoryChip extends StatelessWidget {
  final CategoryEntity category;
  

  const CategoryChip({
    Key? key,
    required this.category,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: (){
      context.goNamed(AppRouteConstants.exploreRouteName,
                extra: SearchParams(query: "", type: SearchType.course,category: category.id));
    },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:  Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category.title,
          style: TextStyle(
            color:  Colors.white ,
            fontWeight:  FontWeight.bold ,
          ),
        ),
      ),
    );
  }
}
class CategoryChipSkeleton extends StatelessWidget {
  final double? width;

  const CategoryChipSkeleton({
    super.key,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width ?? 80, // Default width, can be customized
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}