base class DataState<T> {
  final T? data;
  final Exception? error;

  const DataState({this.data, this.error});
}

final class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

final class DataException<T> extends DataState<T> {
  const DataException(Exception error) : super(error: error);
}