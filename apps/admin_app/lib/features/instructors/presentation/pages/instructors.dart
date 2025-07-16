import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:admin_app/features/instructors/presentation/bloc/cubit/mentor_management_cubit.dart';
import 'package:admin_app/features/instructors/presentation/bloc/cubit/mentor_management_state.dart';
import 'package:admin_app/features/instructors/presentation/widgets/mentor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorsPage extends StatefulWidget {
  const InstructorsPage({super.key});

  @override
  State<InstructorsPage> createState() => _InstructorsPageState();
}

class _InstructorsPageState extends State<InstructorsPage> {
  String searchQuery = '';
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MentorManagementCubit()..displayMentors(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Instructors Management'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: BlocListener<MentorManagementCubit, MentorManagementState>(
          listener: (context, state) {
            if (state is MentorsUpdationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Mentor updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is MentorsUpdationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Failed to update mentor"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            children: [
              // Search and Filter Section
              _buildSearchAndFilter(),
              
              // Mentors List
              Expanded(
                child: BlocBuilder<MentorManagementCubit, MentorManagementState>(
                  builder: (context, state) {
                    if (state is MentorsLoading && state.mentors.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MentorsLoadingError && state.mentors.isEmpty) {
                      return _buildErrorState(context);
                    }

                    final filteredMentors = _filterMentors(state.mentors);
                    return _buildMentorsList(context, filteredMentors);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search instructors...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          
          const SizedBox(height: 12),
          
         
        ],
      ),
    );
  }


  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load mentors',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your connection and try again',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<MentorManagementCubit>().displayMentors(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorsList(BuildContext context, List<MentorEntity> mentors) {
    if (mentors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isNotEmpty ? 'No mentors found' : 'No mentors available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or filters',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MentorManagementCubit>().displayMentors();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mentors.length,
        itemBuilder: (context, index) {
          final mentor = mentors[index];
          return MentorCard(mentor: mentor);
        },
      ),
    );
  }

  List<MentorEntity> _filterMentors(List<MentorEntity> mentors) {
    var filtered = mentors;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((mentor) {
        return mentor.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
               mentor.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
               (mentor.username?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    // Apply status filter
    switch (selectedFilter) {
      case 'Verified':
        filtered = filtered.where((mentor) => mentor.isVerified).toList();
        break;
      case 'Unverified':
        filtered = filtered.where((mentor) => !mentor.isVerified).toList();
        break;
      case 'Email Verified':
        filtered = filtered.where((mentor) => mentor.emailVerified).toList();
        break;
      case 'Has Courses':
        filtered = filtered.where((mentor) => 
          mentor.courseIds != null && mentor.courseIds!.isNotEmpty).toList();
        break;
    }

    return filtered;
  }
}
