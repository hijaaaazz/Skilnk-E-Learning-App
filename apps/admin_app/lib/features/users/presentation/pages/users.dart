import 'package:admin_app/features/users/domain/entities/user_entity.dart';
import 'package:admin_app/features/users/presentation/bloc/cubit/user_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch users when page is built

    return BlocProvider(
      create: (context) => UserManagementCubit()..displayUsers(),
      child: SizedBox(
        
        child: BlocBuilder<UserManagementCubit, UserManagementState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoadingError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    const Text('Failed to load users'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<UserManagementCubit>().displayUsers(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (state is UserLoadingSucces) {
              return _buildUsersList(context, state.users);
            }
            
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, List<UserEntity> users) {
    if (users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
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