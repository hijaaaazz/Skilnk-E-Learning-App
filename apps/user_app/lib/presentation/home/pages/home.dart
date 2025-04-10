

import 'package:flutter/material.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/domain/auth/entity/user.dart';
import 'package:user_app/domain/auth/usecases/get_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserEntity? currentUser;
  String? error;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final usecase = GetCurrentUser(); // Make sure this is a callable class
    final result = await usecase.call(params: NoParams()); // If using `call()`

    result.fold(
      (failure) {
        setState(() {
          error = failure.toString();
        });
      },
      (user) {
        setState(() {
          currentUser = user;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: error != null
            ? Text("Error: $error")
            : currentUser == null
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Name: ${currentUser!.name}"),
                      Text("Email: ${currentUser!.email}"),
                      if (currentUser!.image.isNotEmpty)
                        Image.network(currentUser!.image),
                    ],
                  ),
      ),
    );
  }
}
