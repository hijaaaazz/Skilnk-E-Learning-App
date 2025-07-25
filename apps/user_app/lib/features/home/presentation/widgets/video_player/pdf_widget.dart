// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/theme/app_colors.dart';

class PDFViewerWidget extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerWidget({
    super.key,
    required this.pdfUrl,
  });

  @override
  State<PDFViewerWidget> createState() => _PDFViewerWidgetState();
}

class _PDFViewerWidgetState extends State<PDFViewerWidget> {
  String? localPath;
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 0;
  int totalPages = 0;
  PDFViewController? pdfController;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  @override
  void didUpdateWidget(PDFViewerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pdfUrl != widget.pdfUrl) {
      _loadPDF();
    }
  }

  Future<void> _loadPDF() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        currentPage = 0;
        totalPages = 0;
      });

      if (widget.pdfUrl.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'No PDF URL provided';
        });
        return;
      }

      // Download PDF file with timeout
      final response = await http.get(Uri.parse(widget.pdfUrl)).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Download timeout');
        },
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final fileName = 'lecture_notes_${widget.pdfUrl.hashCode}.pdf';
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes);

        if (mounted) {
          setState(() {
            localPath = file.path;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = 'Failed to load PDF: ${response.statusCode}';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error loading PDF: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    if (localPath == null) {
      return _buildEmptyState();
    }

    return _buildPDFViewer();
  }

  Widget _buildLoadingState() {
    return Container(
      color: const Color(0xFFFAFAFA),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryOrange,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Loading PDF...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: const Color(0xFFFAFAFA),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  // ignore: duplicate_ignore
                  // ignore: deprecated_member_use
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: AppColors.primaryOrange,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Error loading PDF',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage ?? 'Unknown error',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loadPDF,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: const Color(0xFFFAFAFA),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.textLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.description_outlined,
                color: AppColors.textLight,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No notes available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFViewer() {
    return Column(
      children: [
        // Modern PDF Navigation Bar
        if (totalPages > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Page ${currentPage + 1} of $totalPages',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavButton(
                      icon: Icons.keyboard_arrow_up,
                      onPressed: currentPage > 0 ? () => _goToPage(currentPage - 1) : null,
                      isEnabled: currentPage > 0,
                    ),
                    const SizedBox(width: 8),
                    _buildNavButton(
                      icon: Icons.keyboard_arrow_down,
                      onPressed: currentPage < totalPages - 1 ? () => _goToPage(currentPage + 1) : null,
                      isEnabled: currentPage < totalPages - 1,
                    ),
                  ],
                ),
              ],
            ),
          ),

        // PDF Viewer
        Expanded(
          child: Container(
            color: const Color(0xFFFAFAFA),
            child: PDFView(
              filePath: localPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage,
              fitPolicy: FitPolicy.WIDTH,
              preventLinkNavigation: false,
              backgroundColor: const Color(0xFFFAFAFA),
              onRender: (pages) {
                if (mounted) {
                  setState(() {
                    totalPages = pages ?? 0;
                  });
                }
              },
              onError: (error) {
                if (mounted) {
                  setState(() {
                    errorMessage = error.toString();
                  });
                }
              },
              onPageError: (page, error) {
                if (mounted) {
                  setState(() {
                    errorMessage = 'Page $page: $error';
                  });
                }
              },
              onViewCreated: (PDFViewController controller) {
                pdfController = controller;
              },
              onPageChanged: (int? page, int? total) {
                if (mounted) {
                  setState(() {
                    currentPage = page ?? 0;
                    totalPages = total ?? 0;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isEnabled 
            ? AppColors.primaryOrange.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            icon,
            color: isEnabled ? AppColors.primaryOrange : Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _goToPage(int page) {
    pdfController?.setPage(page);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
