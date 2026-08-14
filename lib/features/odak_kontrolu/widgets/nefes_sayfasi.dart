import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/odak_kontrolu_state.dart';
import 'package:flutter/material.dart';

class NefesSayfasi extends StatelessWidget {
  final OdakKontroluState state;
  final Animation<double> nefesOlcek;
  final String nefesMetni;
  final VoidCallback onDevamEt;

  const NefesSayfasi({
    required this.state,
    required this.nefesOlcek,
    required this.nefesMetni,
    required this.onDevamEt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final kategori = state.seciliKategori;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          const Text(
            'Bir Nefes Al',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F6E56),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Karar vermeden önce kendine biraz zaman tanı.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF085041),
            ),
          ),

          const SizedBox(height: 24),

          // Kategori Özet Kartı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x14000000)),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kategori?.arkaplanRengi ?? const Color(0xFFE1F5EE),
                  ),
                  child: Icon(
                    kategori?.ikon ?? Icons.shopping_bag,
                    color: kategori?.simgeRengi ?? const Color(0xFF0F6E56),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  kategori?.isim ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF04342C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Hareketli Daire Animasyonu
          SizedBox(
            width: 150,
            height: 150,
            child: AnimatedBuilder(
              animation: nefesOlcek,
              builder: (context, child) {
                final oran = nefesOlcek.value;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140 * oran,
                      height: 140 * oran,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x260F6E56),
                      ),
                    ),
                    Container(
                      width: 110 * oran,
                      height: 110 * oran,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF0F6E56),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        nefesMetni,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE1F5EE),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 36),

          CustomButton(
            text: 'Devam Et',
            onPressed: onDevamEt,
            backgroundColor: const Color(0xFF0F6E56),
            foregroundColor: Colors.white,
            height: 52,
            borderRadius: 16,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
