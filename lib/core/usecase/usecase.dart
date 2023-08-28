abstract interface class UseCase<Type, Params> {
  Future<Type> call ({Params categoryId});
}