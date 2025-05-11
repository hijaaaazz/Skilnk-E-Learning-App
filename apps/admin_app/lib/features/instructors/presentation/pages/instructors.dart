import 'package:admin_app/common/widgets/app_text.dart';
import 'package:admin_app/common/widgets/dialog.dart';
import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:admin_app/features/instructors/presentation/bloc/cubit/mentor_management_cubit.dart';
import 'package:admin_app/features/instructors/presentation/bloc/cubit/mentor_management_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorsPage extends StatelessWidget {
  const InstructorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MentorManagementCubit()..displayMentors(),
      child: Scaffold(
        body: BlocListener<MentorManagementCubit, MentorManagementState>(
          listener: (context, state) {
            if (state is MentorsUpdationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Mentor updated successfully")),
              );
            } else if (state is MentorsUpdationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to update mentor")),
              );
            }
          },
          child: BlocBuilder<MentorManagementCubit, MentorManagementState>(
            builder: (context, state) {
              if (state is MentorsLoading && state.mentors.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MentorsLoadingError && state.mentors.isEmpty) {
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
              }

              return _buildmentorsList(context, state.mentors);
            },
          ),
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
                TextButton(
                    child:
                    Row(
                      children: [
                        AppText(
                          text: user.isblocked ? "Block" : "Unblock",
                          color: user.isblocked ? Colors.red : Colors.green,
                        ),
                        SizedBox(width: 8),
                        Icon(
                          user.isVerified ? Icons.check_circle : Icons.cancel,
                          color: user.isblocked ? Colors.red : Colors.green,
                        ),],
                    ) ,
                    onPressed: () {
                      CustomDialog.show(
                        context: context,
                        title: user.isblocked ? "Unblock Mentor" : "Block Mentor",
                        content: Text(user.isblocked
                            ? "Are you sure you want to Unblock this mentor?"
                            : "Are you sure you want to block this mentor?"),
                        onDone: () {
                          context.read<MentorManagementCubit>().updateMentor(
                            user.copyWith(isblocked: !user.isblocked),
                          );
                        },
                      );
                      
                    },
                  ),
                user.isVerified?
                AppText(text: "Verified", color: Colors.green):
                TextButton(
                    child:
                    Row(
                      children: [
                        AppText(
                          text: user.isVerified ? "Verify" : "Unverify",
                          color: user.isVerified ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: 8),
                        Icon(
                          user.isVerified ? Icons.check_circle : Icons.cancel,
                          color: user.isVerified ? Colors.green : Colors.red,
                        ),],
                    ) ,
                    onPressed: () {
                      CustomDialog.show(
                        context: context,
                        title: user.isVerified ? "Unverify Mentor" : "Verify Mentor",
                        content: Text(user.isVerified
                            ? "Are you sure you want to unverify this mentor?"
                            : "Are you sure you want to verify this mentor?"),
                        onDone: () {
                          context.read<MentorManagementCubit>().updateMentor(
                            user.copyWith(isVerified: !user.isVerified),
                          );
                        },
                      );
                      
                    },
                  ),
              ]
            ),
          ),
        );
      },
    );
  }
}
