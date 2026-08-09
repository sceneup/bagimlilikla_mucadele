class VerificationCodeRegex {
  /// Örnek:
  /// "doğrulama kodunuz: 583921"
  /// "onay kodu 123456"
  /// "kodunuz 456789"
  static final verificationCode = RegExp(
    r'(doğrulama kodunuz|doğrulama kodu|onay kodunuz|onay kodu|güvenlik kodunuz|güvenlik kodu|tek kullanımlık şifreniz|tek kullanımlık şifre)'
    r'\s*[:\-]?\s*(\d{4,8})',
    caseSensitive: false,
  );
}