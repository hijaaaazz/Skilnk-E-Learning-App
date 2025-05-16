import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/home/presentation/widgets/header_section.dart';
import 'package:user_app/features/home/presentation/widgets/categories-section.dart';
import 'package:user_app/features/home/presentation/widgets/courses_section.dart';
import 'package:user_app/features/home/presentation/widgets/promotion_card.dart';
import 'package:user_app/features/home/presentation/widgets/search_prompt_section.dart';
import 'package:user_app/features/home/presentation/bloc/bloc/course_bloc_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseBlocBloc()..add(FetchCategories()),
      child: Scaffold(
        appBar: HeaderSection(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  
                  SizedBox(height: 16),
                  SearchPromptSection(),
                  SizedBox(height: 24),
                  PromotionCardSection(),
                  SizedBox(height: 24),
                  CategoriesSection(),
                  SizedBox(height: 24),
                  CoursesSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
