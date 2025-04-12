

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/domain/auth/entity/user.dart';
import 'package:user_app/domain/auth/usecases/get_user.dart';
import 'package:user_app/presentation/account/blocs/auth_cubit/auth_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? error;

  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthStatusCubit,AuthStatusState>(
      builder: (context, state) {
        if(state.status == AuthStatus.emailVerified){
          return Scaffold(
        appBar: AppBar(title: const Text('Home Page')),
        body: Center(
          child: error != null
              ? Text("Error: $error")
              : state.user == null
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Name: ${state.user!.name}"),
                        Text("Email: ${state.user!.email}"),
                        
                      ],
                    ),
        ),
      );
        }
        else{
          return Center();
        }
        
      },
      
    );
  }
}
