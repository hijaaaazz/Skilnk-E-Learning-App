import 'package:flutter/material.dart';
import 'dart:async';

class DownloadProgressDialog extends StatefulWidget {
  final String lectureTitle;
  final VoidCallback onDownloadComplete;

  const DownloadProgressDialog({
    super.key,
    required this.lectureTitle,
    required this.onDownloadComplete,
  });

  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog>
    with TickerProviderStateMixin {
  double progress = 0.0;
  bool isDownloading = false;
  bool isCompleted = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startDownload() {
    setState(() {
      isDownloading = true;
      progress = 0.0;
    });

    // Simulate download progress
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        progress += 0.02;
        if (progress >= 1.0) {
          progress = 1.0;
          isDownloading = false;
          isCompleted = true;
          timer.cancel();
          
          // Auto close after completion
          Timer(const Duration(seconds: 1), () {
            widget.onDownloadComplete();
            Navigator.pop(context);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? const Color(0xFF4CAF50) 
                      // ignore: deprecated_member_use
                      : const Color(0xFFFF6636).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.download,
                  color: isCompleted 
                      ? Colors.white 
                      : const Color(0xFFFF6636),
                  size: 40,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Title
              Text(
                isCompleted ? 'Download Complete!' : 'Download Lecture',
                style: const TextStyle(
                  color: Color(0xFF202244),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Lecture title
              Text(
                widget.lectureTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF545454),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 24),
              
              if (isDownloading) ...[
                // Progress bar
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Downloading...',
                          style: TextStyle(
                            color: Color(0xFF545454),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Color(0xFFFF6636),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFF0F0F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6636),
                      ),
                      minHeight: 6,
                    ),
                  ],
                ),
              ] else if (isCompleted) ...[
                const Text(
                  'Lecture downloaded successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else ...[
                // Download options
                Column(
                  children: [
                    const Text(
                      'Choose download quality:',
                      style: TextStyle(
                        color: Color(0xFF545454),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildQualityOption('720p HD', '~150 MB', true),
                    const SizedBox(height: 8),
                    _buildQualityOption('480p', '~80 MB', false),
                    const SizedBox(height: 8),
                    _buildQualityOption('360p', '~50 MB', false),
                  ],
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Action buttons
              if (!isDownloading && !isCompleted) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF545454),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _startDownload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6636),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Download',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualityOption(String quality, String size, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: isSelected ? const Color(0xFFFF6636).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFFFF6636) : const Color(0xFFE0E0E0),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isSelected ? const Color(0xFFFF6636) : const Color(0xFF9E9E9E),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              quality,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFF6636) : const Color(0xFF202244),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            size,
            style: const TextStyle(
              color: Color(0xFF545454),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}