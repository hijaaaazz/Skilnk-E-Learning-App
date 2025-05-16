import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tutor_app/common/widgets/blurred_loading.dart';

class ScreenPdfView extends StatefulWidget {
  final String pathOrUrl;

  const ScreenPdfView({super.key, required this.pathOrUrl});

  @override
  State<ScreenPdfView> createState() => _ScreenPdfViewState();
}

class _ScreenPdfViewState extends State<ScreenPdfView> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _downloadedFilePath;

  bool get isNetworkUrl {
    bool isTrue = widget.pathOrUrl.startsWith('http://') || widget.pathOrUrl.startsWith('https://');
    log("Is network URL: $isTrue");
    return isTrue;
  }

  @override
  void initState() {
    super.initState();
    if (isNetworkUrl) {
      _downloadPdfFile();
    }
  }

  Future<void> _downloadPdfFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create a client with longer timeout
      final client = http.Client();
      try {
        // Add headers to avoid server restrictions
        final response = await client.get(
          Uri.parse(widget.pathOrUrl),
          headers: {
            'User-Agent': 'Mozilla/5.0 Flutter PDF Viewer',
            'Accept': 'application/pdf',
          },
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          if (bytes.isEmpty) {
            throw Exception('PDF file is empty');
          }

          // Save to temporary file
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.pdf');
          await file.writeAsBytes(bytes);
          
          if (mounted) {
            setState(() {
              _downloadedFilePath = file.path;
              _isLoading = false;
            });
          }
        } else {
          throw Exception('Failed to download PDF: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      log("Error downloading PDF: $e");
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load PDF: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          if (isNetworkUrl && _errorMessage != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _downloadPdfFile,
              tooltip: 'Try Again',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlurredLoading(),
            SizedBox(height: 16),
            Text('Downloading PDF...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _downloadPdfFile,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    // For network URLs that have been downloaded successfully
    if (isNetworkUrl && _downloadedFilePath != null) {
      return _buildPdfViewer(_downloadedFilePath!);
    }
    
    // For local files
    if (!isNetworkUrl) {
      return _buildPdfViewer(widget.pathOrUrl);
    }

    // Fallback (should not reach here)
    return const Center(child: Text('Something went wrong'));
  }

  Widget _buildPdfViewer(String filePath) {
    return PDF(
      swipeHorizontal: true,
      enableSwipe: true,
      autoSpacing: true,
      pageFling: true,
      nightMode: false,
      onError: (error) {
        log("Error loading PDF: $error");
        setState(() {
          _errorMessage = 'Error loading PDF: $error';
        });
      },
      onPageError: (page, error) {
        log("Error loading page $page: $error");
      },
      onPageChanged: (page, total) {
        log("Page changed: $page/$total");
      },
    ).fromPath(filePath);
  }

  @override
  void dispose() {
    // Clean up temporary file when done
    if (_downloadedFilePath != null) {
      try {
        File(_downloadedFilePath!).delete();
      } catch (e) {
        log("Error deleting temporary file: $e");
      }
    }
    super.dispose();
  }
}