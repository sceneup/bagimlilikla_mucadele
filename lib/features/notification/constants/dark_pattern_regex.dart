class DarkPatternRegex {
  // "Son 2 ürün"
  // "Son 5 adet"
  static final remainingStock = RegExp(
    r'\b(son|kalan)\s+\d+\s*(ürün|adet)\b',
    caseSensitive: false,
  );

  // "Sadece 3 adet kaldı"
  // "Yalnızca 2 ürün kaldı"
  static final limitedStock = RegExp(
    r'\b(sadece|yalnızca)\s+\d+\s*(adet|ürün)?\s*(kaldı|kalmış)\b',
    caseSensitive: false,
  );

  // "Son 2 saat"
  // "Son 15 dakika"
  // "Kalan 3 gün"
  static final remainingTime = RegExp(
    r'\b(son|kalan)\s+\d+\s*(dakika|saat|gün)\b',
    caseSensitive: false,
  );

  // "127 kişi"
  // "23 kullanıcı"
  static final peopleCount = RegExp(
    r'\b\d+\s*(kişi|kullanıcı)\b',
    caseSensitive: false,
  );

  // "15 dakika içinde"
  // "2 saat içinde"
  static final timeLimit = RegExp(
    r'\b\d+\s*(dakika|saat|gün)\s*(içinde|kaldı)\b',
    caseSensitive: false,
  );

  // "49 TL ek ücret"
  // "49 TL hizmet bedeli"
  static final additionalFee = RegExp(
    r'\b\d+(?:[.,]\d+)?\s*(₺|tl)\s*'
    r'(ek ücret|hizmet bedeli|işlem bedeli)',
    caseSensitive: false,
  );

  // "499 TL + 49 TL"
  static final extraPrice = RegExp(
    r'\+\s*\d+(?:[.,]\d+)?\s*(₺|tl)',
    caseSensitive: false,
  );
}