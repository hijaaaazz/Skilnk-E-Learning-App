import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/common/widgets/app_text.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/presentation/account/blocs/auth_cubit/auth_cubit.dart';

class LoginSuggession extends StatelessWidget {
  const LoginSuggession({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthStatusCubit,AuthStatusState>(
        builder: (context, state) {
          return Visibility(
          visible: context.read<AuthStatusCubit>().state.status == AuthStatus.unauthenticated,
          child: Center(
            child: TextButton(
            
              onPressed: (){
              context.pushNamed(AppRouteConstants.authRouteName);
            }, child: AppText(text:  "Sign Up",
              color: Colors.deepOrange,
              weight: FontWeight.w500,
              size: 20,
            )),
          ));
        },
      );
  }
}