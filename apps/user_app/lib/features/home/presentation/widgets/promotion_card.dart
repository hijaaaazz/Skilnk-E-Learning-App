import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/features/home/data/models/banner_model.dart';
import  'package:user_app/features/home/presentation/bloc/courses/course_bloc_bloc.dart';
import  'package:user_app/features/home/presentation/bloc/courses/course_bloc_state.dart';
import  'package:user_app/features/home/presentation/widgets/skeltons/banner_skelton.dart';

class PromotionCardSection extends StatefulWidget {
  const PromotionCardSection({super.key});

  @override
  State<PromotionCardSection> createState() => _PromotionCardSectionState();
}

class _PromotionCardSectionState extends State<PromotionCardSection> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBlocBloc, CourseBlocState>(
      builder: (context, state) {
        if (state is CourseBlocLoaded) {
          if(state.banners.isEmpty){
            return SizedBox.shrink();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16/7,
                  child: CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: state.banners.length,
                    options: CarouselOptions(
                      viewportFraction: 1,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      enlargeCenterPage: false,
                     
                    ),
                    itemBuilder: (context, index, realIndex) {
                      final banner = state.banners[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: PromotionCard(
                          banner: banner,
                          total: state.banners.length,
                          index: index,
                        ),
                      );
                    },
                  ),
                ),
                
              ],
            ),
          );
        }else{
          return  PromotionCardShimmer();
        }
      },
    );
  }
}

class PromotionCard extends StatelessWidget {
  final BannerModel banner;
  final int total;
  final int index;

  const PromotionCard({
    super.key,
    required this.banner,
    required this.total,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.blue.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles for visual appeal
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            right: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          
          // Content
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                banner.badge,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 45,
            left: 16,
            right: 16,
            child: Text(
              banner.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          Positioned(
            top: 75,
            left: 16,
            right: 16,
            child: Text(
              banner.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}