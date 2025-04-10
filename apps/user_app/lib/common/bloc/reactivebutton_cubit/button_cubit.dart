import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/bloc/reactivebutton_cubit/button_state.dart';

import '../../../core/usecase/usecase.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());


  Future<void> execute({dynamic params, required Usecase usecase}) async {
  emit(ButtonLoadingState());
  print("🚀 execute() called with params: $params");

  try {
    print("🛠 Calling usecase.call()...");
    Either returnedData = await usecase.call(params: params);
    print("✅ usecase.call() completed");

    returnedData.fold(
      (error) {
        print("❌ Error: $error");
        emit(ButtonFailureState(errorMessage: error));
      },
      (data) {
        print("🎉 Success: $data");
        emit(ButtonSuccessState());
      },
    );
  } catch (e) {
    print("🔥 Exception in execute(): $e");
    emit(ButtonFailureState(errorMessage: e.toString()));
  }
}

}