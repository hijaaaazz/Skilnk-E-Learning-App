import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/common/bloc/user_management/user_management_bloc.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showActionIcon;

  const BasicAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showActionIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      actions: actions ??
          (showActionIcon
              ? [
                  BlocBuilder<AuthStatusCubit, AuthStatusState>(
                    builder: (context, state) {
                      if (state is UserLoaded &&
                          state.user!.image != null && state.user!.image!.isNotEmpty ) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed(AppRouteConstants.profileRouteName);
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage:
                                  NetworkImage(""),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ]
              : []),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
