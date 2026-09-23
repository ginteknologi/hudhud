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
  String toString() => 'AppException(statusCode: $statusCode, message: $message)';
}

class NetworkException extends AppException {
  NetworkException({String message = 'Tidak dapat terhubung ke internet. Periksa koneksi Anda.'})
      : super(message: message);
}

class ServerException extends AppException {
  ServerException({String message = 'Terjadi kesalahan pada server. Silakan coba lagi nanti.', int? statusCode})
      : super(message: message, statusCode: statusCode);
}

class UnauthorizedException extends AppException {
  UnauthorizedException({String message = 'Sesi Anda telah berakhir. Silakan login kembali.'})
      : super(message: message, statusCode: 401);
}

class NotFoundException extends AppException {
  NotFoundException({String message = 'Data tidak ditemukan.'})
      : super(message: message, statusCode: 404);
}
