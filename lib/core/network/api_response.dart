class ApiResponse<T> {
  final bool success;
  final int code;
  final String message;
  final T? data;
  final Map<String, dynamic>? rawJson;

  ApiResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
    this.rawJson,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? (json['code'] == 200),
      code: json['code'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      rawJson: json,
    );
  }
}
