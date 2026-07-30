import 'package:bagimlilik/features/odak_kontrolu/models/kategori.dart';
import 'package:flutter/material.dart';

class KategoriService {
  List<Kategori> kategorileriGetir() {
    return const [
      Kategori(
        id: 'giyim',
        isim: 'Giyim',
        ikon: Icons.checkroom,
        arkaplanRengi: Color(0xFFFBEAF0),
        simgeRengi: Color(0xFFC2487D),
      ),
      Kategori(
        id: 'ayakkabi',
        isim: 'Ayakkabı',
        ikon: Icons.directions_walk,
        arkaplanRengi: Color(0xFFFBE9E1),
        simgeRengi: Color(0xFFC56A3E),
      ),
      Kategori(
        id: 'kozmetik',
        isim: 'Kozmetik & Bakım',
        ikon: Icons.spa,
        arkaplanRengi: Color(0xFFF1EAFB),
        simgeRengi: Color(0xFF8E5FC4),
      ),
      Kategori(
        id: 'elektronik',
        isim: 'Elektronik & Teknoloji',
        ikon: Icons.devices,
        arkaplanRengi: Color(0xFFE6F0FB),
        simgeRengi: Color(0xFF3E7FC4),
      ),
      Kategori(
        id: 'aksesuar',
        isim: 'Aksesuar & Çanta',
        ikon: Icons.watch,
        arkaplanRengi: Color(0xFFFBF3E1),
        simgeRengi: Color(0xFFC4933E),
      ),
      Kategori(
        id: 'ev',
        isim: 'Ev & Dekorasyon',
        ikon: Icons.chair,
        arkaplanRengi: Color(0xFFEAF3E1),
        simgeRengi: Color(0xFF6B9C4F),
      ),
      Kategori(
        id: 'hobi',
        isim: 'Hobi & Oyun',
        ikon: Icons.sports_esports,
        arkaplanRengi: Color(0xFFE1F3F0),
        simgeRengi: Color(0xFF35858E),
      ),
      Kategori(
        id: 'kitap',
        isim: 'Kitap & Kırtasiye',
        ikon: Icons.menu_book,
        arkaplanRengi: Color(0xFFE9EAFB),
        simgeRengi: Color(0xFF5E64C4),
      ),
      Kategori(
        id: 'hediyelik',
        isim: 'Hediyelik',
        ikon: Icons.card_giftcard,
        arkaplanRengi: Color(0xFFFBE1E6),
        simgeRengi: Color(0xFFC4425A),
      ),
      Kategori(
        id: 'diger',
        isim: 'Diğer',
        ikon: Icons.more_horiz,
        arkaplanRengi: Color(0xFFEFEFEF),
        simgeRengi: Color(0xFF7A7A7A),
      ),
    ];
  }
}
