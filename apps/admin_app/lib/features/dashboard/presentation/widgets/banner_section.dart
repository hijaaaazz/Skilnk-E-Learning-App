import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_bloc.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_event.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_state.dart';
import 'package:admin_app/features/dashboard/presentation/widgets/banner_edit-dialod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannersSection extends StatelessWidget {
  const BannersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.indigo));
        }

        if (state is DashboardError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: TextStyle(color: Colors.red[700], fontSize: 16),
            ),
          );
        }

        if (state is DashboardLoaded) {
          return state.banners.isEmpty
              ? const Center(
                  child: Text(
                    'No banners found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.banners.length,
                  itemBuilder: (context, index) {
                    final banner = state.banners[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: BannerCard(banner: banner),
                    );
                  },
                );
        }

        return const Center(
          child: Text(
            'No banners found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      },
    );
  }
}
class BannerCard extends StatelessWidget {
  final BannerModel banner;

  const BannerCard({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(-4, -4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           
         
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                        banner.badge,
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                Text(
                  banner.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  banner.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      context: context,
                      icon: Icons.edit,
                      label: 'Edit',
                      color: Colors.blue[600]!,
                      onPressed: () => _showEditDialog(context, banner),
                    ),
                    _buildActionButton(
                      context: context,
                      icon: Icons.delete,
                      label: 'Delete',
                      color: Colors.red[600]!,
                      onPressed: () => _showDeleteDialog(context, banner),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, BannerModel banner) {
    final dashboardBloc = context.read<DashboardBloc>();
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (dialogContext) => BlocProvider.value(
        value: dashboardBloc,
        child: BannerEditDialog(banner: banner),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, BannerModel banner) {
  final dashboardBloc = context.read<DashboardBloc>();
  assert(banner.id.isNotEmpty, 'Banner ID is empty');

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (dialogContext) => BlocProvider.value(
      value: dashboardBloc,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Banner',
          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure you want to delete "${banner.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              debugPrint('Deleting banner with id: ${banner.id}');
              dashboardBloc.add(DeleteBanner(banner.id));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red[600]),
            child: const Text('Delete'),
          ),
        ],
      ),
    ),
  );
}

}