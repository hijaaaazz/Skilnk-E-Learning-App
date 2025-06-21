import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

      // Download PDF file
      final response = await http.get(Uri.parse(widget.pdfUrl));
      
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final fileName = 'lecture_notes_${widget.pdfUrl.hashCode}.pdf';
        final file = File('${dir.path}/$fileName');
        
        await file.writeAsBytes(bytes);
        
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load PDF: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading PDF: $e';
      });
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
      color: Colors.grey[50],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.deepOrange,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Loading PDF...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
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
      color: Colors.grey[50],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.deepOrange,
                size: 40,
              ),
              const SizedBox(height: 12),
              const Text(
                'Error loading PDF',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                errorMessage ?? 'Unknown error',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPDF,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Retry', style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: Colors.grey[50],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              color: Colors.grey,
              size: 40,
            ),
            SizedBox(height: 12),
            Text(
              'No notes available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
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
        // PDF Navigation Bar
        if (totalPages > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Page ${currentPage + 1} of $totalPages',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange[700],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: currentPage > 0 ? () => _goToPage(currentPage - 1) : null,
                      icon: const Icon(Icons.keyboard_arrow_up),
                      color: currentPage > 0 ? Colors.deepOrange : Colors.grey,
                      iconSize: 20,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    IconButton(
                      onPressed: currentPage < totalPages - 1 ? () => _goToPage(currentPage + 1) : null,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      color: currentPage < totalPages - 1 ? Colors.deepOrange : Colors.grey,
                      iconSize: 20,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              ],
            ),
          ),
        
        // PDF Viewer
        Expanded(
          child: Container(
            color: Colors.grey[100],
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
              backgroundColor: Colors.grey[100]!,
              onRender: (pages) {
                setState(() {
                  totalPages = pages ?? 0;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = 'Page $page: $error';
                });
              },
              onViewCreated: (PDFViewController controller) {
                pdfController = controller;
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  currentPage = page ?? 0;
                  totalPages = total ?? 0;
                });
              },
            ),
          ),
        ),
      ],
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
