import 'package:admin_app/features/dashboard/data/models/activity_model.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_bloc.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_event.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_state.dart';
import 'package:admin_app/features/dashboard/presentation/widgets/activities_section.dart';
import 'package:admin_app/features/dashboard/presentation/widgets/banner_edit-dialod.dart';
import 'package:admin_app/features/dashboard/presentation/widgets/banner_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()
        ..add(LoadActivities())
        ..add(LoadBanners()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[100]!, Colors.grey[200]!],
          ),
        ),
        child: Row(
          children: [
            // Left Side - Activities
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.history, color: Colors.indigo, size: 28),
                          SizedBox(width: 12),
                          Text(
                            'Recent Activities',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: ActivitiesSection()),
                  ],
                ),
              ),
            ),
            // Right Side - Banner Management
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.image, color: Colors.indigo, size: 28),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Banner Management',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showCreateBannerDialog(context),
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Create Banner'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo[700],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: BannersSection()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateBannerDialog(BuildContext context) {
    final dashboardBloc = context.read<DashboardBloc>();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (dialogContext) => BlocProvider.value(
        value: dashboardBloc,
        child: const BannerEditDialog(),
      ),
    );
  }
}