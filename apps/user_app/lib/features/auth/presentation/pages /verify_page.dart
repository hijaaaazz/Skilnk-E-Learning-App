import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/auth/domain/entity/user.dart';

class VerifyPage extends StatelessWidget {
  final UserEntity user;
  
  const VerifyPage({
    super.key, 
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthStatusCubit, AuthStatusState>(
      listener: (context, state) {
        if (state.status == AuthStatus.loading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("please wait")),
          );
        }if (state.status == AuthStatus.emailVerified) {
          context.go(AppRouteConstants.personalInfoSubmitingPageName);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('successfully')),
          );
        }
        
         else if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 80,
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Verify Your Email',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'We\'ve sent a verification email to:',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Please check your inbox and click the verification link to continue.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed:(){
                      state.status == AuthStatus.loading ? null : 
                    context.read<AuthStatusCubit>().checkVerification(user);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      minimumSize: const Size(200, 50),
                    ),
                    child: state.status == AuthStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('I\'ve Verified My Email'),
                  ),
                  const SizedBox(height: 16),
                  
                  // Only the timer button is stateful
                  ResendTimerButton(
                    isLoading: state.status == AuthStatus.loading,
                    onResend: () {
                      context.read<AuthStatusCubit>().resendVerificationEmail();
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Didn\'t receive an email?'),
                      TextButton(
                        onPressed: () {
                          // Handle support or troubleshooting
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.deepOrange,
                        ),
                        child: const Text('Contact Support'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Fixed ResendTimerButton with auto-starting timer
class ResendTimerButton extends StatefulWidget {
  final VoidCallback onResend;
  final bool isLoading;
  
  const ResendTimerButton({
    super.key,
    required this.onResend,
    this.isLoading = false,
  });

  @override
  State<ResendTimerButton> createState() => _ResendTimerButtonState();
}

class _ResendTimerButtonState extends State<ResendTimerButton> {
  bool _canResend = false;
  int _remainingSeconds = 60; // Start with 60 seconds
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    // Start timer immediately when widget is created
    _startCountdownTimer();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    // Cancel any existing timer
    _timer?.cancel();
    
    // Create a new timer that fires every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _remainingSeconds = 60;
    });
    _startCountdownTimer();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (_canResend && !widget.isLoading)
        ? () {
            widget.onResend();
            _startResendTimer();
          }
        : null,
      style: TextButton.styleFrom(
        foregroundColor: Colors.deepOrange,
      ),
      child: Text(
        _canResend 
          ? 'Resend Verification Email' 
          : 'Resend in $_remainingSeconds seconds'
      ),
    );
  }
}