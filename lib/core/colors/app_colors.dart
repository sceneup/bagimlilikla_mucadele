import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Ana marka rengi (Butonlar, aktif ikonlar, progress)
  static const Color primary = Color(0xFF7DA78C);

  /// Primary renginin açık tonu (Seçili kartlar, chipler)
  static const Color primaryContainer = Color(0xFFC2D099);

  /// Hafif vurgu / Bilgilendirme kutuları
  static const Color secondaryContainer = Color(0xFFE6EEC9);

  static const Color secondaryContainer2 = Color(0xFFEBEDE3);

  /// Vurgu rengi (Grafikler, AI kartları, özel butonlar)
  static const Color accent = Color(0xFF35858E);

  static const Color green = Color(0xff7EC151);
  static const Color blue = Color(0xFF99C2FF);

  static const Color purple2 = Color(0xFFC47BE4);

  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);

  // Form Elemanları
  static const border = Color(0xFFD1D5DB);
  static const hint = Color(0xFF9CA3AF);

  // Durum Renkleri
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);


}