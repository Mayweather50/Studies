import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Ошибка сервера']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Ошибка авторизации']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Нет подключения к интернету']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Ошибка кэша']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Ошибка загрузки файла']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Ошибка валидации']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Не найдено']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Нет доступа']);
}
