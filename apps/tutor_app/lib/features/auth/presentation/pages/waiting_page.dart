import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_event.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_state.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dispatch the event as soon as the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Dispatch the event to check verification
      BlocProvider.of<AuthBloc>(context).add(CheckIfUserVerifiedByAdminEvent(user: context.read<AuthBloc>().state.user!));
    });

    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: BlocProvider.of<AuthBloc>(context).stream,  // Listen to the stream of the AuthBloc
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFFDF4700)),
            );
          }

          final state = snapshot.data!;

          if (state.status == AuthStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFFDF4700)),
            );
          }

          if (state is AuthAdminVerified) {
            // When verification is successful
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Verification successful")),
              );
              context.goNamed(AppRouteConstants.homeRouteName);
            });
          }

          if (state.status == AuthStatus.failure) {
            // When verification fails
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Verification failed")),
              );
            });
          }

          // Default waiting UI
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
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
                          'VERIFICATION IN PROCESS',
                          style: TextStyle(
                            color: Color(0xFFDF4700),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Please wait while we verify your information. This may take some time.',
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
