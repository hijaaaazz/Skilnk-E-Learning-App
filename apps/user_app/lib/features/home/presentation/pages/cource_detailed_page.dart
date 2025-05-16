import 'package:flutter/material.dart';
import 'package:user_app/features/home/presentation/widgets/course_fueture_.item.dart';
import 'package:user_app/features/home/presentation/widgets/course_review_card.dart';
import 'package:user_app/features/home/presentation/widgets/section_tile.dart';
import 'package:user_app/features/home/presentation/widgets/tab_selecter.dart';
class CourseDetailPage extends StatefulWidget {
  //final String courseId;

  const CourseDetailPage({
    Key? key,
    //required this.courseId,
  }) : super(key: key);

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1626785774573-4b799315345d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2071&q=80",
                      ),
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
                              const Text(
                                'Graphic Design',
                                style: TextStyle(
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
                                    '4.2',
                                    style: TextStyle(
                                      color: const Color(0xFF202244),
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
                          const Text(
                            'Design Principles: Organizing Visual Elements',
                            style: TextStyle(
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
                                '21 Classes',
                                style: TextStyle(
                                  color: const Color(0xFF202244),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
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
                                '42 Hours',
                                style: TextStyle(
                                  color: const Color(0xFF202244),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '₹499',
                                style: TextStyle(
                                  color: const Color(0xFFFF6636),
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
                          ? _buildAboutTab()
                          : _buildCurriculumTab(),
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

            // Instructor Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'Instructor'),
                  const SizedBox(height: 16),
                  Row(
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
                        children: [
                          const Text(
                            'Robert Jr',
                            style: TextStyle(
                              color: Color(0xFF202244),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Graphic Design',
                            style: TextStyle(
                              color: const Color(0xFF545454),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                  _buildFeaturesList(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reviews Section
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
                  const CourseReviewCard(
                    name: 'Will',
                    rating: 4.5,
                    review:
                        'This course has been very useful. Mentor was well spoken totally loved it.',
                    likes: 578,
                    timeAgo: '2 Weeks Ago',
                    imageUrl:
                        'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
                  ),
                  const SizedBox(height: 16),
                  const CourseReviewCard(
                    name: 'Martha E. Thompson',
                    rating: 4.5,
                    review:
                        'This course has been very useful. Mentor was well spoken totally loved it. It had fun sessions as well.',
                    likes: 578,
                    timeAgo: '2 Weeks Ago',
                    imageUrl:
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Enroll Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: _buildEnrollButton(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Graphic Design now a popular profession graphic design by off your carrer about tantas regiones barbarorum pedibus obiit',
          style: TextStyle(
            color: const Color(0xFFA0A4AB),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.46,
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    'Graphic Design n a popular profession l Cur tantas regiones barbarorum pedibus obiit, maria transmi Et ne nimium beatus est; Addidisti ad extremum etiam ',
                style: TextStyle(
                  color: const Color(0xFFA0A4AB),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.46,
                ),
              ),
              TextSpan(
                text: 'Read More',
                style: TextStyle(
                  color: const Color(0xFFFF6636),
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

  Widget _buildCurriculumTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        5,
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
                      'Module ${index + 1}: Introduction to Design',
                      style: const TextStyle(
                        color: Color(0xFF202244),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '4 lessons • 45 minutes',
                      style: TextStyle(
                        color: const Color(0xFF545454),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.lock_open,
                color: Color(0xFF202244),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {'icon': Icons.book, 'text': '25 Lessons'},
      {'icon': Icons.devices, 'text': 'Access Mobile, Desktop & TV'},
      {'icon': Icons.signal_cellular_alt, 'text': 'Beginner Level'},
      {'icon': Icons.headphones, 'text': 'Audio Book'},
      {'icon': Icons.access_time, 'text': 'Lifetime Access'},
      {'icon': Icons.quiz, 'text': '100 Quizzes'},
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

  Widget _buildEnrollButton() {
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
              'Enroll Course - ₹499',
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
