import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:admin_app/features/instructors/presentation/bloc/cubit/mentor_management_cubit.dart';
import 'package:admin_app/features/instructors/presentation/bloc/cubit/mentor_management_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorsPage extends StatelessWidget {
  const InstructorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch mentors when page is built

    return BlocProvider(
      create: (context) => MentorManagementCubit()..displayMentors(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mentors'),
          actions: [
           
          ],
        ),
        body: BlocBuilder<MentorManagementCubit, MentorManagementState>(
          builder: (context, state) {
            if (state is MentorsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MentorsLoadingError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    const Text('Failed to load mentors'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<MentorManagementCubit>().displayMentors(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (state is MentorsLoadingSucces) {
              return _buildmentorsList(context, state.mentors);
            }
            
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  Widget _buildmentorsList(BuildContext context, List<MentorEntity> mentors) {
    if (mentors.isEmpty) {
      return const Center(child: Text('No mentors found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: mentors.length,
      itemBuilder: (context, index) {
        final user = mentors[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Block button - just shows a snackbar as dummy action
                IconButton(
                  icon: const Icon(Icons.block, color: Colors.red),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Blocked user: ${user.name}')),
                    );
                  },
                ),
                // Unblock button - just shows a snackbar as dummy action
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unblocked user: ${user.name}')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}