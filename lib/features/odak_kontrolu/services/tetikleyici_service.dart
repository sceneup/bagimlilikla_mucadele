import 'package:bagimlilik/features/odak_kontrolu/models/tetikleyici.dart';
import 'package:flutter/material.dart';

class TetikleyiciService {
  List<Tetikleyici> tetikleyicileriGetir() {
    return const [
      Tetikleyici(
        id: 'sosyal_medya',
        isim: 'Sosyal Medya Reklamı',
        ikon: Icons.campaign,
        arkaplanRengi: Color(0xFFE6F0FB),
        simgeRengi: Color(0xFF3E7FC4),
      ),
      Tetikleyici(
        id: 'indirim',
        isim: 'İndirim / Kampanya Baskısı',
        ikon: Icons.local_offer,
        arkaplanRengi: Color(0xFFFBF3E1),
        simgeRengi: Color(0xFFC4933E),
      ),
      Tetikleyici(
        id: 'stres',
        isim: 'Can Sıkıntısı / Stres',
        ikon: Icons.sentiment_dissatisfied,
        arkaplanRengi: Color(0xFFF1EAFB),
        simgeRengi: Color(0xFF8E5FC4),
      ),
      Tetikleyici(
        id: 'sosyal_etki',
        isim: 'Sosyal Etki',
        ikon: Icons.groups,
        arkaplanRengi: Color(0xFFFBEAF0),
        simgeRengi: Color(0xFFC2487D),
      ),
      Tetikleyici(
        id: 'vitrin',
        isim: 'Vitrin / Mağazada Görme',
        ikon: Icons.storefront,
        arkaplanRengi: Color(0xFFE1F3F0),
        simgeRengi: Color(0xFF35858E),
      ),
      Tetikleyici(
        id: 'kredi_karti',
        isim: '"Sonra Öderim" Rahatlığı',
        ikon: Icons.payments,
        arkaplanRengi: Color(0xFFFBE1E6),
        simgeRengi: Color(0xFFC4425A),
      ),
      Tetikleyici(
        id: 'bilmiyorum',
        isim: 'Bilmiyorum / Diğer',
        ikon: Icons.help_outline,
        arkaplanRengi: Color(0xFFEFEFEF),
        simgeRengi: Color(0xFF7A7A7A),
      ),
    ];
  }
}
