import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_app/features/account/presentation/pages%20/account.dart';
import 'package:user_app/presentation/account/widgets/app_bar.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  Future<void> _launchEmail() async {
    final String email = 'mhcnkd4@gmail.com';
    final String subject = Uri.encodeComponent('Support Request');
    final String body = Uri.encodeComponent('Hello, I need help with...');

    final Uri emailUri = Uri.parse('mailto:$email?subject=$subject&body=$body');

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showErrorSnackBar('Could not launch email app');
      }
    } catch (e) {
      _showErrorSnackBar('Error launching email: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showEmailConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CustomConfirmationDialog(
        title: 'Send Support Email',
        description: 'Are you sure you want to send an email to our support team?',
        icon: Icons.email_outlined,
        iconColor: Colors.deepOrange.shade400,
        iconBackgroundColor: Colors.deepOrange.shade50,
        confirmText: 'Send',
        confirmColor: Colors.deepOrange,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          _launchEmail();
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkilnkAppBar(title: "Help & Support",),
      body: Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight,

        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   // colors: [
          //   //   Color.fromARGB(255, 243, 157, 28),
          //   //   Colors.deepOrange,
          //   // ],
          // ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                
                _buildContactSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.deepOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.help_center,
            size: 60,
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 20),
          Text(
            'Help & Support',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We\'re here to help you succeed',
            style: TextStyle(
              fontSize: 16,
              // ignore: deprecated_member_use
              color: Colors.deepOrange.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          _buildContactItem(Icons.email, 'mhcnkd4@gmail.com'),
          _buildContactItem(Icons.phone, '+91 8714330170'),
          _buildContactItem(Icons.access_time, 'Mon-Fri: 9AM-6PM IST'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showEmailConfirmation(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mail, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    'Send Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange, size: 20),
          const SizedBox(width: 15),
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFF718096),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}