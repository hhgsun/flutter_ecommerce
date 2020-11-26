class ApiResponse<T> {
  T data;
  bool isError;
  String errMessage;
  ApiResponse({
    this.data,
    this.isError,
    this.errMessage,
  });
}
