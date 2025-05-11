import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_event.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_state.dart';

class VerifyPage extends StatelessWidget {
   const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthBloc>().state.user;
      if (user != null) {
        BlocProvider.of<AuthBloc>(context).add(CheckVerificationEvent(user: user));
      }
    });

    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: BlocProvider.of<AuthBloc>(context).stream,
        builder: (context, snapshot) {
          final state = snapshot.data ?? context.read<AuthBloc>().state;

          if (state.status == AuthStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFDF4700)),
            );
          }

          if (state is AuthEmailVerified) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Email verification successful")),
              );
              context.goNamed(AppRouteConstants.waitingRouteName);
            });
          }

          if (state.status == AuthStatus.failure) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Email verification failed")),
              );
            });
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFFFF3E0)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.hourglass_top,
                    size: 70,
                    color: Color(0xFFDF4700),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDF4700).withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'EMAIL VERIFICATION IN PROCESS',
                          style: TextStyle(
                            color: Color(0xFFDF4700),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Please wait while we verify your email. This may take a few moments.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 30),
                        CircularProgressIndicator(
                          color: Color(0xFFDF4700),
                          strokeWidth: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
