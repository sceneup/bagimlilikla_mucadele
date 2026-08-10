class VerificationCodeRegex {
  // ============================================================
  // İŞLEM / ALIŞVERİŞ BAĞLAMI
  // ============================================================

  static final transactionContext = RegExp(
    r'\b('
    r'harcamanız|'
    r'harcamaniz|'
    r'harcama|'
    r'alışverişiniz|'
    r'alisverisiniz|'
    r'alışveriş|'
    r'alisveris|'
    r'siparişiniz|'
    r'siparisiniz|'
    r'sipariş|'
    r'siparis|'
    r'ödemeniz|'
    r'odemeniz|'
    r'ödeme|'
    r'isleminiz|'
    r'işleminiz|'
    r'islem|'
    r'işlem|'
    r'satın alım|'
    r'satin alim|'
    r'satın alma|'
    r'satin alma|'
    r'kartınızla|'
    r'kartinizla|'
    r'kartınızdan|'
    r'kartinizdan'
    r')\b',
    caseSensitive: false,
  );

  // ============================================================
  // DOĞRULAMA KODU
  // ============================================================

  static final verificationCode = RegExp(
    r'(?:'
    r'doğrulama\s+kodunuz|'
    r'doğrulama\s+kodu|'
    r'onay\s+kodunuz|'
    r'onay\s+kodu|'
    r'güvenlik\s+kodunuz|'
    r'güvenlik\s+kodu|'
    r'tek\s+kullanımlık\s+şifreniz|'
    r'tek\s+kullanımlık\s+şifre|'
    r'tek\s+kullanımlık\s+kodunuz|'
    r'tek\s+kullanımlık\s+kodu|'
    r'şifreniz|'
    r'şifre|'
    r'sifreniz|'
    r'sifre|'
    r'kodunuz|'
    r'kodu'
    r')'
    r'\s*'
    r'[:\-]?'
    r'\s*'
    r'(\d{4,8})\b',
    caseSensitive: false,
  );

  // ============================================================
  // TL TUTARI
  // ============================================================

  static final amount = RegExp(
    r'(\d{1,3}(?:[.]\d{3})*(?:,\d{1,2})?|\d+(?:,\d{1,2})?)'
    r'\s*TL\b',
    caseSensitive: false,
  );

  // ============================================================
  // İŞYERİ / MAĞAZA
  // ============================================================

  static final merchant = RegExp(
    r'^\s*(.*?)\s+işyerinden\b',
    caseSensitive: false,
    multiLine: true,
  );
}