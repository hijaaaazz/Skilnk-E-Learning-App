// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class VerificationWaitingPage extends StatefulWidget {
//   const VerificationWaitingPage({super.key});

//   @override
//   State<VerificationWaitingPage> createState() => _VerificationWaitingPageState();
// }

// class _VerificationWaitingPageState extends State<VerificationWaitingPage> {
//   late Timer _timer;
//   bool _isVerified = false;
//   bool _isSending = false;
//   String _message = '';

//   @override
//   void initState() {
//     super.initState();
//     _sendVerificationEmail(); // send email on load
//     _startVerificationCheckLoop(); // start checking
//   }

//   Future<void> _sendVerificationEmail() async {
//     try {
//       setState(() {
//         _isSending = true;
//         _message = '';
//       });

//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//         setState(() {
//           _message = 'Verification email sent!';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _message = 'Failed to send email: $e';
//       });
//     } finally {
//       setState(() => _isSending = false);
//     }
//   }

//   void _startVerificationCheckLoop() {
//     _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
//       final user = FirebaseAuth.instance.currentUser;
//       await user?.reload();

//       if (user != null && user.emailVerified) {
//         _timer.cancel();
//         setState(() => _isVerified = true);
//         Navigator.pushReplacementNamed(context, '/home'); // Change route as needed
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Verify your Email')),
//       body: Center(
//         child: _isVerified
//             ? const Text('Email verified! Redirecting...')
//             : Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const CircularProgressIndicator(),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'We’ve sent a verification link to your email.\nPlease check your inbox or spam folder.',
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 20),
//                     if (_message.isNotEmpty)
//                       Text(
//                         _message,
//                         style: const TextStyle(color: Colors.green),
//                       ),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: _isSending ? null : _sendVerificationEmail,
//                       child: _isSending
//                           ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
//                           : const Text('Resend Verification Email'),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
