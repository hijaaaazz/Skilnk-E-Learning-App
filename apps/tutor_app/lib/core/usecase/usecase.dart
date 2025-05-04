abstract class Usecase<Type,Params> {
  

Future<Type> call({required Params params});
}

class NoParams {}
abstract class StreamUsecase<Type, Params> {
  Stream<Type> call({required Params params});
}
