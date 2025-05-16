import 'package:flutter/material.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/entity/lecture_entity.dart';
import 'package:user_app/features/home/presentation/widgets/course_fueture_.item.dart';
import 'package:user_app/features/home/presentation/widgets/course_review_card.dart';
import 'package:user_app/features/home/presentation/widgets/section_tile.dart';
import 'package:user_app/features/home/presentation/widgets/tab_selecter.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseEntity course;

  const CourseDetailPage({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

// 

class _CourseDetailPageState extends State<CourseDetailPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Header Image
            Stack(
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: NetworkImage(course.courseThumbnail),
                      fit: BoxFit.cover,
                      opacity: 0.7,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            // Course Info Card
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category and Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                course.categoryName,
                                style: const TextStyle(
                                  color: Color(0xFFFF6B00),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xFFFF6B00),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    course.averageRating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Color(0xFF202244),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Course Title
                          Text(
                            course.title,
                            style: const TextStyle(
                              color: Color(0xFF202244),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Course Stats
                          Row(
                            children: [
                              const Icon(
                                Icons.play_lesson,
                                size: 16,
                                color: Color(0xFF202244),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${course.lessons.length} Classes',
                                style: const TextStyle(
                                  color: Color(0xFF202244),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '|',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Color(0xFF202244),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${course.duration} Hours',
                                style: const TextStyle(
                                  color: Color(0xFF202244),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              // Show discounted price if there's an offer
                              if (course.offerPercentage > 0)
                                Text(
                                  '₹${calculateDiscountedPrice(course.price, course.offerPercentage)}',
                                  style: const TextStyle(
                                    color: Color(0xFFFF6636),
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              else
                                Text(
                                  '₹${course.price}',
                                  style: const TextStyle(
                                    color: Color(0xFFFF6636),
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Tabs
                    TabSelector(
                      tabs: const ['About', 'Curriculum'],
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),

                    // Tab Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: _selectedTabIndex == 0
                          ? _buildAboutTab(course)
                          : _buildCurriculumTab(course),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Action Button
            Center(
              child: Container(
                width: 63,
                height: 63,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF167F71),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 13,
                      offset: Offset(1, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),

            // Instructor Section (You would need to fetch instructor details from a service)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'Instructor'),
                  const SizedBox(height: 16),
                  // You would need to get instructor details based on course.tutorId
                  _buildInstructorWidget(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // What You'll Get Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'What You\'ll Get'),
                  const SizedBox(height: 16),
                  _buildFeaturesList(course),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reviews Section
            if (course.totalReviews > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SectionTitle(title: 'Reviews'),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'SEE ALL',
                            style: TextStyle(
                              color: Color(0xFFFF6636),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // You would need to fetch actual review data based on course.reviews
                    _buildReviewsSection(course),
                  ],
                ),
              ),
            const SizedBox(height: 32),

            // Enroll Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: _buildEnrollButton(course),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  int calculateDiscountedPrice(int originalPrice, int discountPercentage) {
    if (discountPercentage <= 0 || discountPercentage > 100) {
      return originalPrice;
    }
    
    final discount = (originalPrice * discountPercentage) ~/ 100;
    return originalPrice - discount;
  }

  Widget _buildAboutTab(CourseEntity course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.description,
          style: const TextStyle(
            color: Color(0xFFA0A4AB),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.46,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: course.description,
                style: const TextStyle(
                  color: Color(0xFFA0A4AB),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.46,
                ),
              ),
              const TextSpan(
                text: 'Read More',
                style: TextStyle(
                  color: Color(0xFFFF6636),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  height: 1.46,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurriculumTab(CourseEntity course) {
    final lessons = course.lessons;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lessons.length,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8FE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8F1FF), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6636),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lessons[index].title,
                      style: const TextStyle(
                        color: Color(0xFF202244),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lessons[index].duration} minutes',
                      style: const TextStyle(
                        color: Color(0xFF545454),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                true ? Icons.lock : Icons.lock_open,
                color: const Color(0xFF202244),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Temporary instructor widget until you implement instructor data fetching
  Widget _buildInstructorWidget() {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Instructor Name', // Replace with actual instructor name
              style: TextStyle(
                color: Color(0xFF202244),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Specialization', // Replace with actual specialization
              style: TextStyle(
                color: Color(0xFF545454),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturesList(CourseEntity course) {
    final features = [
      {'icon': Icons.book, 'text': '${course.lessons.length} Lessons'},
      {'icon': Icons.devices, 'text': 'Access Mobile, Desktop & TV'},
      {'icon': Icons.signal_cellular_alt, 'text': '${course.level} Level'},
      {'icon': Icons.language, 'text': '${course.language}'},
      {'icon': Icons.access_time, 'text': 'Lifetime Access'},
      {'icon': Icons.quiz, 'text': 'Quizzes & Tests'},
      {'icon': Icons.workspace_premium, 'text': 'Certificate of Completion'},
    ];

    return Column(
      children: features
          .map((feature) => CourseFeatureItem(
                icon: feature['icon'] as IconData,
                text: feature['text'] as String,
              ))
          .toList(),
    );
  }

  // Temporary review section - you would need to fetch actual review data
  Widget _buildReviewsSection(CourseEntity course) {
    // Showing dummy reviews for now
    return Column(
      children: [
        const CourseReviewCard(
          name: 'Student Name',
          rating: 4.5,
          review: 'This course has been very useful. Mentor was well spoken and I totally loved it.',
          likes: 34,
          timeAgo: '2 Weeks Ago',
          imageUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36',
        ),
        const SizedBox(height: 16),
        if (course.totalReviews > 1)
          const CourseReviewCard(
            name: 'Another Student',
            rating: 4.0,
            review: 'Great content and well-structured lessons. I learned a lot from this course.',
            likes: 21,
            timeAgo: '3 Weeks Ago',
            imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
          ),
      ],
    );
  }

  Widget _buildEnrollButton(CourseEntity course) {
    String buttonText = 'Enroll Course';
    if (course.price > 0) {
      if (course.offerPercentage > 0) {
        final discountedPrice = calculateDiscountedPrice(course.price, course.offerPercentage);
        buttonText = 'Enroll Course - ₹$discountedPrice';
      } else {
        buttonText = 'Enroll Course - ₹${course.price}';
      }
    }

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6636),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6636).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Color(0xFFFF6636),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// You'll need to add or update the LectureEntity class if it doesn't exist
// This is based on usage in the code above, adjust as needed
/*
class LectureEntity {
  final String id;
  final String title;
  final int duration; // in minutes
  final bool isLocked;
  
  LectureEntity({
    required this.id,
    required this.title,
    required this.duration,
    this.isLocked = true,
  });
}
*/