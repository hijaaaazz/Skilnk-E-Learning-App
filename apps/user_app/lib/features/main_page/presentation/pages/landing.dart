import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import  'package:user_app/core/routes/app_route_constants.dart';
import  'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/account/presentation/pages%20/account.dart';
import  'package:user_app/features/main_page/presentation/widgets/navigation_bar.dart';
class LandingPage extends StatefulWidget {
  const LandingPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Stream<DocumentSnapshot>? _blockStream;
  late final String? userId;

  @override
  void initState() {
    super.initState();
    userId = context.read<AuthStatusCubit>().state.user?.userId;

    if (userId != null) {
      _blockStream = FirebaseFirestore.instance.collection('users').doc(userId).snapshots();

    _blockStream!.listen((docSnapshot) {
  if (docSnapshot.exists) {
    final data = docSnapshot.data() as Map<String, dynamic>?;

    if (data != null && data['isBlocked'] == true) {
      _showBlockedDialog(context);
    }
  }
});

    }
  }
void _showBlockedDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomConfirmationDialog(
      title: 'Access Denied',
      description: 'Your account has been blocked by the admin.',
      icon: Icons.block,
      iconColor: Colors.white,
      iconBackgroundColor: Colors.red,
      confirmText: 'Login',
      confirmColor: Colors.red,
      onCancel: (){
        context.read<AuthStatusCubit>().logOut();
        context.pop();
      },
      onConfirm: () {
        context.read<AuthStatusCubit>().logOut();
        context.goNamed(AppRouteConstants.authRouteName);
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: buildBottomNavbar(widget.navigationShell),
    );
  }
}
