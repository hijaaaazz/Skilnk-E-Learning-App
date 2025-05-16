import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';

class HeaderSection extends StatelessWidget implements PreferredSizeWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AuthStatusCubit, AuthStatusState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.only(left: 20,right: 20, top: 15),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  state.user?.name != null ? "Hi ${state.user!.name}" : 'Hi, Friend',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
