class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache error occurred'});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'Network error occurred'});
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({this.message = 'Server error occurred', this.statusCode});
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException({this.message = 'Resource not found'});
}
