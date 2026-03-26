class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Ошибка сервера']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Ошибка авторизации']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Нет подключения к интернету']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Ошибка кэша']);
}

class StorageException implements Exception {
  final String message;
  const StorageException([this.message = 'Ошибка загрузки файла']);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Не найдено']);
}
