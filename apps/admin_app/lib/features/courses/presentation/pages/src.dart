import 'package:admin_app/features/courses/data/models/course_model.dart';


class CourseService {
  static List<CourseModel> getMockCourses() {
    return [
      CourseModel(
        id: '1',
        title: 'Complete Flutter Development Course',
        titleLower: 'complete flutter development course',
        description: 'Master Flutter from basics to advanced concepts including state management, animations, and deployment. Build real-world cross-platform applications.',
        duration: 18000, // 5 hours in seconds
        enrolledCount: 1250,
        price: 99,
        offerPercentage: 20,
        category: 'mobile-development',
        categoryName: 'Mobile Development',
        courseThumbnail: 'https://via.placeholder.com/300x200/4285F4/FFFFFF?text=Flutter',
        language: 'English',
        level: 'Intermediate',
        tutor: 'John Smith',
        averageRating: 4.8,
        totalReviews: 324,
        isActive: true,
        isBanned: false,
        listed: true,
        notificationSent: true,
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 12, 1),
        lessons: [
          Lesson(
            title: 'Introduction to Flutter',
            description: 'Learn the fundamentals of Flutter and Dart',
            durationInSeconds: 1800,
            videoUrl: 'https://example.com/video1',
            notesUrl: 'https://example.com/notes1',
          ),
          Lesson(
            title: 'Widgets and Layouts',
            description: 'Understanding Flutter widgets and building layouts',
            durationInSeconds: 2400,
            videoUrl: 'https://example.com/video2',
            notesUrl: 'https://example.com/notes2',
          ),
          Lesson(
            title: 'State Management',
            description: 'Managing app state with Provider and Bloc',
            durationInSeconds: 3000,
            videoUrl: 'https://example.com/video3',
            notesUrl: 'https://example.com/notes3',
          ),
        ],
        ratingBreakdown: RatingBreakdown(
          oneStar: 2,
          twoStar: 5,
          threeStar: 18,
          fourStar: 89,
          fiveStar: 210,
        ),
      ),
      CourseModel(
        id: '2',
        title: 'Advanced Dart Programming',
        titleLower: 'advanced dart programming',
        description: 'Deep dive into advanced Dart concepts, async programming, and modern development techniques for Flutter applications.',
        duration: 21600, // 6 hours
        enrolledCount: 890,
        price: 129,
        offerPercentage: 15,
        category: 'programming',
        categoryName: 'Programming',
        courseThumbnail: 'https://via.placeholder.com/300x200/00D2B8/FFFFFF?text=Dart',
        language: 'English',
        level: 'Advanced',
        tutor: 'Sarah Johnson',
        averageRating: 4.9,
        totalReviews: 156,
        isActive: true,
        isBanned: false,
        listed: true,
        notificationSent: false,
        createdAt: DateTime(2024, 2, 20),
        updatedAt: DateTime(2024, 11, 15),
        lessons: [
          Lesson(
            title: 'Advanced Dart Features',
            description: 'Exploring advanced Dart language features',
            durationInSeconds: 2700,
            videoUrl: 'https://example.com/video4',
            notesUrl: 'https://example.com/notes4',
          ),
          Lesson(
            title: 'Async Programming',
            description: 'Mastering Future, Stream, and async/await',
            durationInSeconds: 3600,
            videoUrl: 'https://example.com/video5',
            notesUrl: 'https://example.com/notes5',
          ),
        ],
        ratingBreakdown: RatingBreakdown(
          oneStar: 1,
          twoStar: 2,
          threeStar: 8,
          fourStar: 45,
          fiveStar: 100,
        ),
      ),
      CourseModel(
        id: '3',
        title: 'UI/UX Design for Mobile Apps',
        titleLower: 'ui/ux design for mobile apps',
        description: 'Learn the principles of mobile UI/UX design. Create beautiful and functional mobile app interfaces with modern design patterns.',
        duration: 14400, // 4 hours
        enrolledCount: 2100,
        price: 79,
        offerPercentage: 25,
        category: 'design',
        categoryName: 'Design',
        courseThumbnail: 'https://via.placeholder.com/300x200/FF6B6B/FFFFFF?text=UI%2FUX',
        language: 'English',
        level: 'Beginner',
        tutor: 'Mike Chen',
        averageRating: 4.6,
        totalReviews: 445,
        isActive: true,
        isBanned: false,
        listed: true,
        notificationSent: true,
        createdAt: DateTime(2024, 3, 10),
        updatedAt: DateTime(2024, 12, 5),
        lessons: [
          Lesson(
            title: 'Mobile Design Principles',
            description: 'Understanding fundamental mobile design principles',
            durationInSeconds: 2400,
            videoUrl: 'https://example.com/video6',
            notesUrl: 'https://example.com/notes6',
          ),
          Lesson(
            title: 'Color and Typography',
            description: 'Mastering color and typography in mobile design',
            durationInSeconds: 1800,
            videoUrl: 'https://example.com/video7',
            notesUrl: 'https://example.com/notes7',
          ),
        ],
        ratingBreakdown: RatingBreakdown(
          oneStar: 8,
          twoStar: 12,
          threeStar: 35,
          fourStar: 140,
          fiveStar: 250,
        ),
      ),
      CourseModel(
        id: '4',
        title: 'Firebase for Flutter Developers',
        titleLower: 'firebase for flutter developers',
        description: 'Complete guide to integrating Firebase services in Flutter apps including authentication, Firestore, storage, and cloud functions.',
        duration: 25200, // 7 hours
        enrolledCount: 1680,
        price: 149,
        offerPercentage: 30,
        category: 'backend',
        categoryName: 'Backend Development',
        courseThumbnail: 'https://via.placeholder.com/300x200/FFA726/FFFFFF?text=Firebase',
        language: 'English',
        level: 'Intermediate',
        tutor: 'Dr. Emily Rodriguez',
        averageRating: 4.7,
        totalReviews: 289,
        isActive: true,
        isBanned: false,
        listed: true,
        notificationSent: false,
        createdAt: DateTime(2024, 1, 25),
        updatedAt: DateTime(2024, 11, 20),
        lessons: [
          Lesson(
            title: 'Firebase Setup and Authentication',
            description: 'Setting up Firebase and implementing authentication',
            durationInSeconds: 3600,
            videoUrl: 'https://example.com/video8',
            notesUrl: 'https://example.com/notes8',
          ),
          Lesson(
            title: 'Firestore Database Integration',
            description: 'Working with Firestore in Flutter applications',
            durationInSeconds: 4200,
            videoUrl: 'https://example.com/video9',
            notesUrl: 'https://example.com/notes9',
          ),
        ],
        ratingBreakdown: RatingBreakdown(
          oneStar: 3,
          twoStar: 7,
          threeStar: 25,
          fourStar: 98,
          fiveStar: 156,
        ),
      ),
    ];
  }

  static CourseModel? getCourseById(String id) {
    try {
      return getMockCourses().firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<String> getCategories() {
    return [
      'All Categories',
      'Mobile Development',
      'Programming',
      'Design',
      'Backend Development',
    ];
  }

  static List<String> getLevels() {
    return [
      'All Levels',
      'Beginner',
      'Intermediate',
      'Advanced',
    ];
  }
}
