class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  AppException({
    required this.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() =>
      'AppException(statusCode: $statusCode, message: $message)';
}

class NetworkException extends AppException {
  NetworkException({
    super.message = 'Tidak dapat terhubung ke internet. Periksa koneksi Anda.',
  });
}

class ServerException extends AppException {
  ServerException({
    super.message = 'Terjadi kesalahan pada server. Silakan coba lagi nanti.',
    super.statusCode,
  });
}

class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'Sesi Anda telah berakhir. Silakan login kembali.',
  }) : super(statusCode: 401);
}

class NotFoundException extends AppException {
  NotFoundException({super.message = 'Data tidak ditemukan.'})
      : super(statusCode: 404);
}
