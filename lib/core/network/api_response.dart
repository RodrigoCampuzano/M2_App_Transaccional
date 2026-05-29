class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    required this.statusCode,
  });

  factory ApiResponse.success({
    required T data,
    String? message,
    int statusCode = 200,
  }) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({required String message, int statusCode = 500}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}
