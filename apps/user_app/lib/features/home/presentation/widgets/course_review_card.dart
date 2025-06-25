// import 'package:flutter/material.dart';

// class CourseReviewCard extends StatelessWidget {
//   final String name;
//   final double rating;
//   final String review;
//   final int likes;
//   final String timeAgo;
//   final String imageUrl;

//   const CourseReviewCard({
//     super.key,
//     required this.name,
//     required this.rating,
//     required this.review,
//     required this.likes,
//     required this.timeAgo,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 46,
//                 height: 46,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     image: NetworkImage(imageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   name,
//                   style: const TextStyle(
//                     color: Color(0xFF202244),
//                     fontSize: 17,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE8F1FF),
//                   borderRadius: BorderRadius.circular(13),
//                   border: Border.all(
//                     width: 2,
//                     color: const Color(0xFFFF6636),
//                   ),
//                 ),
//                 child: Text(
//                   rating.toString(),
//                   style: const TextStyle(
//                     color: Color(0xFF202244),
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             review,
//             style: TextStyle(
//               color: const Color(0xFF545454),
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//               height: 1.38,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               // const Icon(
//               //   Icons.thumb_up_alt_outlined,
//               //   size: 16,
//               //   color: Color(0xFF202244),
//               // ),
//               // const SizedBox(width: 4),
//               // Text(
//               //   likes.toString(),
//               //   style: TextStyle(
//               //     color: const Color(0xFF202244),
//               //     fontSize: 12,
//               //     fontWeight: FontWeight.w800,
//               //   ),
//               // ),
//               // const SizedBox(width: 16),
//               const Icon(
//                 Icons.access_time,
//                 size: 16,
//                 color: Color(0xFF202244),
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 timeAgo,
//                 style: TextStyle(
//                   color: const Color(0xFF202244),
//                   fontSize: 12,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
