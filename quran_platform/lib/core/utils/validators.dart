class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Неверный формат email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите номер телефона';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Неверный формат номера';
    }
    return null;
  }

  static String? required(String? value, [String fieldName = 'поле']) {
    if (value == null || value.trim().isEmpty) {
      return 'Заполните $fieldName';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите имя';
    }
    if (value.trim().length < 2) {
      return 'Имя слишком короткое';
    }
    return null;
  }

  static String? smsCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите код';
    }
    if (value.length != 6) {
      return 'Код должен содержать 6 цифр';
    }
    return null;
  }
}
