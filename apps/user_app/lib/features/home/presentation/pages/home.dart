import 'package:flutter/material.dart';
import 'package:user_app/features/home/presentation/widgets/categories-section.dart';
import 'package:user_app/features/home/presentation/widgets/courses_section.dart';
import 'package:user_app/features/home/presentation/widgets/header_section.dart';
import 'package:user_app/features/home/presentation/widgets/promotion_card.dart';

// Example of updating your body layout to use the SliverAppBar approach
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Use the HeaderSectionSliver component here
            const HeaderSectionSliver(),
            
            // Convert your other sections to slivers
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  const PromotionCardSection(),
                  const SizedBox(height: 24),
                  const CategoriesSection(),
                  const SizedBox(height: 24),
                  const CoursesSection(),
                  const SizedBox(height: 24),
                  const CategoriesSection(),
                  const SizedBox(height: 24),
                  const CoursesSection(),
                  
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}