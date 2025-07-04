import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:user_app/presentation/account/widgets/app_bar.dart';

// Model for document items
class DocumentItem {
  final String title;
  final String subtitle;
  final String assetPath;
  final IconData icon;
  final Color color;

  DocumentItem({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.icon,
    required this.color,
  });
}

class LegalDocumentsPage extends StatelessWidget {
  // Color scheme
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color deepOrange = Color(0xFFE55722);
  static const Color lightOrange = Color(0xFFFF8A65);
  static const Color accentOrange = Color(0xFFFFAB91);
  static const Color darkOrange = Color(0xFFBF360C);
  static const Color cream = Color(0xFFFFF8F5);
  static const Color offWhite = Color(0xFFFAFAFA);

  // List of documents
  final List<DocumentItem> documents = [
    DocumentItem(
      title: 'Terms & Conditions',
      subtitle: 'Legal agreement and usage terms',
      assetPath: 'assets/markdowns/terms_and_conditions.md',
      icon: Icons.description,
      color: primaryOrange,
    ),
    DocumentItem(
      title: 'Privacy Policy',
      subtitle: 'How we handle your data',
      assetPath: 'assets/markdowns/privacy_policy.md',
      icon: Icons.privacy_tip,
      color: deepOrange,
    ),
    DocumentItem(
      title: 'About App',
      subtitle: 'App information and features',
      assetPath: 'assets/markdowns/about.md',
      icon: Icons.info,
      color: lightOrange,
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cream, offWhite, Colors.white],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < documents.length) {
                      return _buildDocumentCard(context, documents[index]);
                    }
                    return SizedBox(height: 40); // Bottom padding
                  },
                  childCount: documents.length + 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: primaryOrange,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Legal Documents',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryOrange, deepOrange],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Icon(
                  Icons.folder_open,
                  size: 60,
                  color: Colors.white.withOpacity(0.9),
                ),
                SizedBox(height: 10),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, DocumentItem document) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: document.color.withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navigateToDocument(context, document),
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        document.color,
                        document.color.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: document.color.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    document.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        document.subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: document.color,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDocument(BuildContext context, DocumentItem document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkdownViewerPage(document: document),
      ),
    );
  }
}

class MarkdownViewerPage extends StatefulWidget {
  final DocumentItem document;

  const MarkdownViewerPage({Key? key, required this.document}) : super(key: key);

  @override
  _MarkdownViewerPageState createState() => _MarkdownViewerPageState();
}

class _MarkdownViewerPageState extends State<MarkdownViewerPage> {
  String markdownContent = '';
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadMarkdownFile();
  }

  Future<void> _loadMarkdownFile() async {
    try {
      final content = await rootBundle.loadString(widget.document.assetPath);
      setState(() {
        markdownContent = content;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          widget.document.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: widget.document.color,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF8F5),
              Color(0xFFFAFAFA),
              Colors.white,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(widget.document.color),
            ),
            SizedBox(height: 20),
            Text(
              'Loading document...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Error loading document',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please check if the file exists:\n${widget.document.assetPath}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.document.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Go Back',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.document.color.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Markdown(
        data: markdownContent,
        styleSheet: MarkdownStyleSheet(
          h1: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.document.color,
            height: 1.5,
          ),
          h2: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: widget.document.color,
            height: 1.4,
          ),
          h3: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            height: 1.3,
          ),
          p: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.6,
          ),
          listBullet: TextStyle(
            color: widget.document.color,
            fontSize: 16,
          ),
          blockquote: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
            fontSize: 15,
          ),
          code: TextStyle(
            backgroundColor: Colors.grey[100],
            color: widget.document.color,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}

/* 
Add these dependencies to your pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  flutter_markdown: ^0.6.18

And add your markdown files to pubspec.yaml:

flutter:
  assets:
    - assets/markdown/terms_conditions.md
    - assets/markdown/privacy_policy.md
    - assets/markdown/about_app.md
    - assets/markdown/user_guidelines.md

Create the folder structure:
assets/
  markdown/
    terms_conditions.md
    privacy_policy.md
    about_app.md
    user_guidelines.md
*/