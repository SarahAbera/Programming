class Response<T> {
  final T? data;
  final String? error;

  Response.success(this.data) : error = null;
  Response.error(this.error) : data = null;
}