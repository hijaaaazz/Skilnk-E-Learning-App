// import 'package:flutter/material.dart';
// import 'package:user_app/features/home/domain/entity/course-entity.dart';
// import 'package:user_app/features/home/presentation/widgets/course_fueture_.item.dart';
// import 'package:user_app/features/home/presentation/widgets/course_review_card.dart';
// import 'package:user_app/features/home/presentation/widgets/section_tile.dart';
// import 'package:user_app/features/home/presentation/widgets/tab_selecter.dart';

// class CourseDetailPage extends StatefulWidget {
//   final CourseEntity course;

//   const CourseDetailPage({
//     Key? key,
//     required this.course,
//   }) : super(key: key);

//   @override
//   State<CourseDetailPage> createState() => _CourseDetailPageState();
// }

// class _CourseDetailPageState extends State<CourseDetailPage> {
//   int _selectedTabIndex = 0;
//   final ScrollController _scrollController = ScrollController();
//   bool _isCardPinned = false;
//   final double _imageHeight = 200.0;
//   final double _infoCardHeight = 130.0; // Approximate height of course info card

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       if (_scrollController.hasClients) {
//         // Toggle card pinned state when scroll position exceeds image height
//         final shouldPin = _scrollController.offset > _imageHeight - _infoCardHeight / 2;
//         if (_isCardPinned != shouldPin) {
//           setState(() {
//             _isCardPinned = shouldPin;
//           });
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final course = widget.course;
    
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Course Image at the top
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: _imageHeight,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 image: DecorationImage(
//                   image: NetworkImage(course.courseThumbnail),
//                   fit: BoxFit.cover,
//                   opacity: 0.7,
//                 ),
//               ),
//             ),
//           ),
          
//           // Back Button and Bookmark
//           Positioned(
//             top: MediaQuery.of(context).padding.top,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () => Navigator.of(context).pop(),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.bookmark_border, color: Colors.white),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           // Main scrollable content
//           CustomScrollView(
//             controller: _scrollController,
//             slivers: [
//               // Empty space for the image
//               SliverToBoxAdapter(
//                 child: SizedBox(height: _imageHeight - _infoCardHeight / 2),
//               ),
              
//               // Main content
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Add some spacing for the course info card when not pinned
//                       SizedBox(height: _infoCardHeight + 16),
                      
//                       // Tabs
//                       TabSelector(
//                         tabs: const ['About', 'Curriculum'],
//                         selectedIndex: _selectedTabIndex,
//                         onTabSelected: (index) {
//                           setState(() {
//                             _selectedTabIndex = index;
//                           });
//                         },
//                       ),
                      
//                       // Tab Content
//                       Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: _selectedTabIndex == 0
//                             ? _buildAboutTab(course)
//                             : _buildCurriculumTab(course),
//                       ),
                      
//                       // Instructor Section
//                       const SectionTitle(title: 'Instructor'),
//                       const SizedBox(height: 16),
//                       // const InstructorCard(
//                       //   name: 'Instructor Name',
//                       //   specialization: 'Specialization',
//                       //   imageUrl: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
//                       // ),
//                       const SizedBox(height: 24),
                      
//                       // What You'll Get Section
//                       const SectionTitle(title: 'What You\'ll Get'),
//                       const SizedBox(height: 16),
//                       _buildFeaturesList(course),
//                       const SizedBox(height: 24),
                      
//                       // Reviews Section
//                       if (course.totalReviews > 0) ...[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const SectionTitle(title: 'Reviews'),
//                             TextButton(
//                               onPressed: () {},
//                               child: const Text(
//                                 'SEE ALL',
//                                 style: TextStyle(
//                                   color: Color(0xFFFF6636),
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         _buildReviewsSection(course),
//                       ],
                      
//                       // Extra space at the bottom for the fixed enroll button
//                       const SizedBox(height: 100),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
          
//           // Pinned Course Info Card
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             top: _isCardPinned ? 0 : _imageHeight - _infoCardHeight / 2,
//             left: 0,
//             right: 0,
//             child: _buildCourseInfoCard(course),
//           ),
          
//           // Fixed Enroll Button at the bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, -5),
//                   ),
//                 ],
//               ),
//               child: _buildEnrollButton(course),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCourseInfoCard(CourseEntity course) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(
//           bottom: const Radius.circular(16),
//           top: _isCardPinned ? Radius.zero : const Radius.circular(16),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.only(
//         top: _isCardPinned ? MediaQuery.of(context).padding.top + 8 : 20,
//         bottom: 20,
//         left: 20,
//         right: 20,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Category and Rating
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 course.categoryName,
//                 style: const TextStyle(
//                   color: Color(0xFFFF6B00),
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.star,
//                     color: Color(0xFFFF6B00),
//                     size: 16,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     course.averageRating.toStringAsFixed(1),
//                     style: const TextStyle(
//                       color: Color(0xFF202244),
//                       fontSize: 11,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),

//           // Course Title
//           Text(
//             course.title,
//             style: const TextStyle(
//               color: Color(0xFF202244),
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Course Stats
//           Row(
//             children: [
//               const Icon(
//                 Icons.play_lesson,
//                 size: 16,
//                 color: Color(0xFF202244),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 '${course.lessons.length} Classes',
//                 style: const TextStyle(
//                   color: Color(0xFF202244),
//                   fontSize: 11,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 '|',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               const Icon(
//                 Icons.access_time,
//                 size: 16,
//                 color: Color(0xFF202244),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 '${course.duration} Hours',
//                 style: const TextStyle(
//                   color: Color(0xFF202244),
//                   fontSize: 11,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               const Spacer(),
//               // Show price
//               if (course.price > 0)
//                 Text(
//                   course.offerPercentage > 0
//                       ? '₹${calculateDiscountedPrice(course.price, course.offerPercentage)}'
//                       : '₹${course.price}',
//                   style: const TextStyle(
//                     color: Color(0xFFFF6636),
//                     fontSize: 21,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 )
//               else
//                 const Text(
//                   'Free',
//                   style: TextStyle(
//                     color: Color(0xFFFF6636),
//                     fontSize: 21,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Your other widget methods remain the same
//   Widget _buildAboutTab(CourseEntity course) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           course.description,
//           style: const TextStyle(
//             color: Color(0xFFA0A4AB),
//             fontSize: 13,
//             fontWeight: FontWeight.w700,
//             height: 1.46,
//           ),
//           maxLines: 3,
//           overflow: TextOverflow.ellipsis,
//         ),
//         const SizedBox(height: 16),
//         RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: course.description,
//                 style: const TextStyle(
//                   color: Color(0xFFA0A4AB),
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   height: 1.46,
//                 ),
//               ),
//               const TextSpan(
//                 text: 'Read More',
//                 style: TextStyle(
//                   color: Color(0xFFFF6636),
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   decoration: TextDecoration.underline,
//                   height: 1.46,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCurriculumTab(CourseEntity course) {
//     final lessons = course.lessons;
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: List.generate(
//         lessons.length,
//         (index) => Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF4F8FE),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: const Color(0xFFE8F1FF), width: 1),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFFF6636),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     '${index + 1}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       lessons[index].title,
//                       style: const TextStyle(
//                         color: Color(0xFF202244),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${lessons[index].duration} minutes',
//                       style: const TextStyle(
//                         color: Color(0xFF545454),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 true ? Icons.lock : Icons.lock_open,
//                 color: const Color(0xFF202244),
//                 size: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFeaturesList(CourseEntity course) {
//     final features = [
//       {'icon': Icons.book, 'text': '${course.lessons.length} Lessons'},
//       {'icon': Icons.devices, 'text': 'Access Mobile, Desktop & TV'},
//       {'icon': Icons.signal_cellular_alt, 'text': '${course.level} Level'},
//       {'icon': Icons.language, 'text': '${course.language}'},
//       {'icon': Icons.access_time, 'text': 'Lifetime Access'},
//       {'icon': Icons.quiz, 'text': 'Quizzes & Tests'},
//       {'icon': Icons.workspace_premium, 'text': 'Certificate of Completion'},
//     ];

//     return Column(
//       children: features
//           .map((feature) => CourseFeatureItem(
//                 icon: feature['icon'] as IconData,
//                 text: feature['text'] as String,
//               ))
//           .toList(),
//     );
//   }

//   Widget _buildReviewsSection(CourseEntity course) {
//     return Column(
//       children: [
//         const CourseReviewCard(
//           name: 'Student Name',
//           rating: 4.5,
//           review: 'This course has been very useful. Mentor was well spoken and I totally loved it.',
//           likes: 34,
//           timeAgo: '2 Weeks Ago',
//           imageUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36',
//         ),
//         const SizedBox(height: 16),
//         if (course.totalReviews > 1)
//           const CourseReviewCard(
//             name: 'Another Student',
//             rating: 4.0,
//             review: 'Great content and well-structured lessons. I learned a lot from this course.',
//             likes: 21,
//             timeAgo: '3 Weeks Ago',
//             imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
//           ),
//       ],
//     );
//   }

//   Widget _buildEnrollButton(CourseEntity course) {
//     String buttonText = 'Enroll Course';
//     if (course.price > 0) {
//       if (course.offerPercentage > 0) {
//         final discountedPrice = calculateDiscountedPrice(course.price, course.offerPercentage);
//         buttonText = 'Enroll Course - ₹$discountedPrice';
//       } else {
//         buttonText = 'Enroll Course - ₹${course.price}';
//       }
//     } else {
//       buttonText = 'Enroll Course - Free';
//     }

//     return Container(
//       height: 60,
//       decoration: BoxDecoration(
//         color: const Color(0xFFFF6636),
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFFF6636).withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Center(
//             child: Text(
//               buttonText,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Positioned(
//             right: 6,
//             top: 6,
//             child: Container(
//               width: 48,
//               height: 48,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.arrow_forward,
//                 color: Color(0xFFFF6636),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   int calculateDiscountedPrice(int originalPrice, int discountPercentage) {
//     if (discountPercentage <= 0 || discountPercentage > 100) {
//       return originalPrice;
//     }
    
//     final discount = (originalPrice * discountPercentage) ~/ 100;
//     return originalPrice - discount;
//   }
// }
