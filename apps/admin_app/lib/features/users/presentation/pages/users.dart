import 'package:admin_app/features/users/domain/entities/user_entity.dart';
import 'package:admin_app/features/users/presentation/bloc/cubit/user_management_cubit.dart';
import 'package:admin_app/features/users/presentation/widgets/student-card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String searchQuery = '';
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserManagementCubit()..displayUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users Management'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: BlocListener<UserManagementCubit, UserManagementState>(
          listener: (context, state) {
            if (state is UserUpdationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is UserUpdationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error ?? "Failed to update user"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            children: [
              // Search and Filter Section
              _buildSearchAndFilter(),
              
              // Users List
              Expanded(
                child: BlocBuilder<UserManagementCubit, UserManagementState>(
                  builder: (context, state) {
                    if (state is UsersLoading && state.users.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is UserLoadingError && state.users.isEmpty) {
                      return _buildErrorState(context, state.error);
                    }

                    final filteredUsers = _filterUsers(state.users);
                    return _buildUsersList(context, filteredUsers, state);
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
              hintText: 'Search users by name or email...',
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
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Active'),
                _buildFilterChip('Blocked'),
                _buildFilterChip('Email Verified'),
                _buildFilterChip('Recently Active'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = selectedFilter == filter;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(filter),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = selected ? filter : 'All';
          });
        },
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? error) {
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
            'Failed to load users',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error ?? 'Please check your connection and try again',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<UserManagementCubit>().displayUsers(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, List<UserEntity> users, UserManagementState state) {
    if (users.isEmpty) {
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
              searchQuery.isNotEmpty ? 'No users found' : 'No users available',
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
        context.read<UserManagementCubit>().displayUsers();
      },
      child: Column(
        children: [
          // Stats Row
          _buildStatsRow(users),
          
          // Users List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserCard(user: user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(List<UserEntity> users) {
    final totalUsers = users.length;
    final activeUsers = users.where((u) => !u.isBlocked).length;
    final blockedUsers = users.where((u) => u.isBlocked).length;
    final verifiedUsers = users.where((u) => u.emailVerified).length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Total', totalUsers, Colors.blue),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('Active', activeUsers, Colors.green),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('Blocked', blockedUsers, Colors.red),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('Verified', verifiedUsers, Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<UserEntity> _filterUsers(List<UserEntity> users) {
    var filtered = users;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        return user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
               user.email.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Apply status filter
    switch (selectedFilter) {
      case 'Active':
        filtered = filtered.where((user) => !user.isBlocked).toList();
        break;
      case 'Blocked':
        filtered = filtered.where((user) => user.isBlocked).toList();
        break;
      case 'Email Verified':
        filtered = filtered.where((user) => user.emailVerified).toList();
        break;
      case 'Recently Active':
        filtered = filtered.where((user) {
          if (user.lastLogin == null) return false;
          final daysSinceLogin = DateTime.now().difference(user.lastLogin!).inDays;
          return daysSinceLogin <= 7; // Active within last 7 days
        }).toList();
        break;
    }

    return filtered;
  }
}
