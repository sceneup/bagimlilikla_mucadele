class AppValidators {
  AppValidators._();

  /// Boş alan kontrolü
  static String? required(
      String? value, {
        String fieldName = "Bu alan",
      }) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName boş bırakılamaz.";
    }
    return null;
  }

  /// E-posta doğrulama
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "E-posta boş bırakılamaz.";
    }

    final emailRegex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return "Geçerli bir e-posta adresi giriniz.";
    }

    return null;
  }

  /// Şifre doğrulama
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Şifre boş bırakılamaz.";
    }

    if (value.length < 8) {
      return "Şifre en az 8 karakter olmalıdır.";
    }

    return null;
  }

  /// Şifre tekrar doğrulama
  static String? confirmPassword(
      String? value,
      String password,
      ) {
    if (value == null || value.isEmpty) {
      return "Şifrenizi tekrar giriniz.";
    }

    if (value != password) {
      return "Şifreler eşleşmiyor.";
    }

    return null;
  }
  static String? minimumAge(
      DateTime? birthDate, {
        int age = 18,
      }) {
    if (birthDate == null) {
      return "Doğum Tarihi boş bırakılamaz.";
    }

    final today = DateTime.now();

    int calculatedAge = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month &&
            today.day < birthDate.day)) {
      calculatedAge--;
    }

    if (calculatedAge < age) {
      return "18 yaşından büyük olmalısınız.";
    }

    return null;
  }
}