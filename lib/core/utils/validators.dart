/// Utilidad de validación de campos del formulario
class Validators {
  // Validación de email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }

    return null;
  }

  // Validación de contraseña
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (value.length > 50) {
      return 'La contraseña no puede superar los 50 caracteres';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una mayúscula';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'La contraseña debe contener al menos una minúscula';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un número';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'La contraseña debe contener al menos un carácter especial';
    }

    return null;
  }

  // Validación de confirmación de contraseña
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }

    if (value != password) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  // Validación de nombre (soporta caracteres en español)
  static String? validateName(String? value, {String fieldName = 'El nombre'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }

    if (value.length < 2) {
      return '$fieldName debe tener al menos 2 caracteres';
    }

    if (value.length > 100) {
      return '$fieldName no puede superar los 100 caracteres';
    }

    final nameRegex = RegExp(r"^[a-zA-ZáéíóúüñÁÉÍÓÚÜÑ\s\-']+$");
    if (!nameRegex.hasMatch(value)) {
      return '$fieldName contiene caracteres inválidos';
    }

    return null;
  }

  // Validación de teléfono (opcional)
  static String? validatePhoneOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return 'Ingresa un número de teléfono válido';
    }

    return null;
  }

  // Validación de teléfono (requerido)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de teléfono es requerido';
    }

    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return 'Ingresa un número de teléfono válido';
    }

    return null;
  }

  // Campo requerido genérico
  static String? validateRequired(
    String? value, {
    String fieldName = 'Este campo',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  // Longitud mínima
  static String? validateMinLength(
    String? value,
    int minLength, {
    String fieldName = 'El campo',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }

    if (value.length < minLength) {
      return '$fieldName debe tener al menos $minLength caracteres';
    }

    return null;
  }

  // Longitud máxima
  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String fieldName = 'El campo',
  }) {
    if (value != null && value.length > maxLength) {
      return '$fieldName no puede superar los $maxLength caracteres';
    }

    return null;
  }

  // URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'La URL es requerida';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Ingresa una URL válida';
    }

    return null;
  }

  // Número
  static String? validateNumber(
    String? value, {
    String fieldName = 'El número',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }

    final number = num.tryParse(value);
    if (number == null) {
      return 'Ingresa un número válido';
    }

    return null;
  }

  // Entero
  static String? validateInteger(
    String? value, {
    String fieldName = 'El número',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Ingresa un número entero válido';
    }

    return null;
  }

  // Rango
  static String? validateRange(
    String? value, {
    required double min,
    required double max,
    String fieldName = 'El valor',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Ingresa un número válido';
    }

    if (number < min || number > max) {
      return '$fieldName debe estar entre $min y $max';
    }

    return null;
  }

  // Fecha pasada
  static String? validatePastDate(
    DateTime? value, {
    String fieldName = 'La fecha',
  }) {
    if (value == null) {
      return '$fieldName es requerida';
    }

    if (value.isAfter(DateTime.now())) {
      return '$fieldName no puede ser en el futuro';
    }

    return null;
  }

  // Fecha futura
  static String? validateFutureDate(
    DateTime? value, {
    String fieldName = 'La fecha',
  }) {
    if (value == null) {
      return '$fieldName es requerida';
    }

    if (value.isBefore(DateTime.now())) {
      return '$fieldName no puede ser en el pasado';
    }

    return null;
  }

  // Tarjeta de crédito (algoritmo de Luhn)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de tarjeta es requerido';
    }

    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    if (!RegExp(r'^\d+$').hasMatch(cardNumber)) {
      return 'Número de tarjeta inválido';
    }

    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'Longitud de tarjeta inválida';
    }

    int sum = 0;
    bool isEven = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    if (sum % 10 != 0) {
      return 'Número de tarjeta inválido';
    }

    return null;
  }

  // Fecha de vencimiento (MM/YY)
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'La fecha de vencimiento es requerida';
    }

    final expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
    if (!expiryRegex.hasMatch(value)) {
      return 'Formato inválido (MM/AA)';
    }

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');

    final now = DateTime.now();
    final expiry = DateTime(year, month);

    if (expiry.isBefore(DateTime(now.year, now.month))) {
      return 'La tarjeta ha expirado';
    }

    return null;
  }

  // CVV
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'El CVV es requerido';
    }

    if (!RegExp(r'^\d{3,4}$').hasMatch(value)) {
      return 'CVV inválido';
    }

    return null;
  }

  // Nombre de usuario
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre de usuario es requerido';
    }

    if (value.length < 3) {
      return 'El nombre de usuario debe tener al menos 3 caracteres';
    }

    if (value.length > 30) {
      return 'El nombre de usuario no puede superar los 30 caracteres';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Solo letras, números, guiones y guiones bajos';
    }

    return null;
  }

  // Código postal
  static String? validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'El código postal es requerido';
    }

    final postalRegex = RegExp(r'^[A-Z0-9\s-]{3,10}$', caseSensitive: false);
    if (!postalRegex.hasMatch(value)) {
      return 'Código postal inválido';
    }

    return null;
  }
}
