import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/bloc/cubit/button_cubit.dart';
import 'package:user_app/common/bloc/cubit/button_state.dart';
import '../../../core/usecase/usecase.dart';

class CustomButton extends StatelessWidget {
  final Usecase usecase;
  final dynamic params;
  final String buttonText;

  const CustomButton({
    Key? key,
    required this.usecase,
    required this.params,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        return TextButton(
          onPressed: state is ButtonLoadingState
              ? null // Disable button when loading
              : () {
                  context.read<ButtonStateCubit>().execute(
                        params: params,
                        usecase: usecase,
                      );
                },
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: state is ButtonLoadingState
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(state is ButtonFailureState ? "Retry" : buttonText),
        );
      },
    );
  }
}
