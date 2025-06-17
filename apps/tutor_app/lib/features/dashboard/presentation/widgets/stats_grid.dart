import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_state.dart';
import 'package:tutor_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/stats-card.dart';

class StatsGrid extends StatelessWidget {
  final DashboardData data;

  const StatsGrid({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    
    return SizedBox(
      width: double.infinity,
      child: Column(
              children: [
                StatCard(
                  value: data.students,
                  label: 'Students',
                  backgroundColor: Color(0xFFFFEFEF),
                  icon: Icon(Icons.people),
                  iconColor: Colors.redAccent, // Soft red tone
                ),
                SizedBox(height: 12),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return StatCard(
                      value: state.user?.courseIds?.length.toString() ?? "yrfduyr",
                      label: 'Courses',
                      backgroundColor: Color(0xFFE1F7E3),
                      icon: Icon(Icons.my_library_books_rounded),
                      iconColor: Colors.green, // Matches the green background
                    );
                  },
                ),
                SizedBox(height: 12),
                StatCard(
                  value: data.totalEarning,
                  label: 'Total Earning',
                  backgroundColor: Color(0xFFF5F7FA),
                  icon: Icon(Icons.attach_money),
                  iconColor: Colors.blueGrey, // Subtle neutral color
                ),
                SizedBox(height: 12),
                StatCard(
                  value: data.courseSold,
                  label: 'Course Sold',
                  backgroundColor: Color(0xFFEBEBFF),
                  icon: Icon(Icons.shopping_cart),
                  iconColor: Colors.deepPurple, // Matches blue-purple background
                ),

              ],
            )
          
    );
  }
}