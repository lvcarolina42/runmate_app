class Result<T, E> {
  final T? data;
  final E? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => data != null;
  bool get isFailure => error != null;

  void onSuccess(Function(T) onSuccess) {
    onSuccess.call(data as T);
  }

  void onFailure(Function(E) onFailure) {
    onFailure.call(error as E);
  }

  void processResult({
    required Function(T) onSuccess,
    required Function(E) onFailure,
  }) {
    if (isSuccess) {
      this.onSuccess(onSuccess);
    }
    if (isFailure) {
      this.onFailure(onFailure);
    }
  }
}
