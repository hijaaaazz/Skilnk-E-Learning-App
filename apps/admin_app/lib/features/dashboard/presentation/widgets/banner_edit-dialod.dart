import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_bloc.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannerEditDialog extends StatefulWidget {
  final BannerModel? banner;

  const BannerEditDialog({super.key, this.banner});

  @override
  State<BannerEditDialog> createState() => _BannerEditDialogState();
}

class _BannerEditDialogState extends State<BannerEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _badgeController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.banner?.title ?? '');
    _badgeController = TextEditingController(text: widget.banner?.badge ?? '');
    _descriptionController = TextEditingController(text: widget.banner?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _badgeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.grey[100],
      title: Text(
        widget.banner == null ? 'Create Banner' : 'Edit Banner',
        style: const TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_titleController, 'Title'),
              const SizedBox(height: 16),
              _buildTextField(_badgeController, 'Badge'),
              const SizedBox(height: 16),
              _buildTextField(_descriptionController, 'Description', maxLines: 3),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: _saveBanner,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(widget.banner == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(-4, -4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          labelStyle: const TextStyle(color: Colors.indigo),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        maxLines: maxLines,
      ),
    );
  }

  void _saveBanner() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Title and Description are required'),
          backgroundColor: Colors.red[600],
        ),
      );
      return;
    }

    final banner = BannerModel(
      id: widget.banner?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      badge: _badgeController.text,
      description: _descriptionController.text,
    );

    if (widget.banner == null) {
      context.read<DashboardBloc>().add(CreateBanner(banner));
    } else {
      context.read<DashboardBloc>().add(UpdateBanner(banner));
    }

    Navigator.pop(context);
  }
}