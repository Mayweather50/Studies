import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashService {
  final FirebaseCrashlytics _crashlytics;

  CrashService(this._crashlytics);

  /// Инициализация: перехват всех необработанных ошибок
  Future<void> init() async {
    // Отключаем в debug-режиме, чтобы не засорять консоль
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    // Перехват ошибок Flutter framework (рендеринг, layout и т.д.)
    FlutterError.onError = _crashlytics.recordFlutterFatalError;

    // Перехват ошибок вне Flutter (async, isolates)
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Установить ID пользователя для привязки крашей
  Future<void> setUser(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// Очистить пользователя при выходе
  Future<void> clearUser() async {
    await _crashlytics.setUserIdentifier('');
  }

  /// Записать не-фатальную ошибку (API ошибки, валидация и т.д.)
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason ?? 'non-fatal error',
      fatal: fatal,
    );
  }

  /// Добавить лог-сообщение (видно в Crashlytics при краше)
  void log(String message) {
    _crashlytics.log(message);
  }

  /// Добавить пользовательские данные к крашу
  Future<void> setCustomKey(String key, Object value) async {
    await _crashlytics.setCustomKey(key, value);
  }
}
