import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/odak_kontrolu_state.dart';
import 'package:flutter/material.dart';

class KararSayfasi extends StatelessWidget {
  final OdakKontroluState state;
  final VoidCallback onBeklemeyeEkle;
  final VoidCallback onVazgec;

  const KararSayfasi({
    required this.state,
    required this.onBeklemeyeEkle,
    required this.onVazgec,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          const Text(
            'Şimdi karar vermek zorunda değilsin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F6E56),
            ),
          ),

          const SizedBox(height: 32),

          // Kum saati çemberi
          Container(
            width: 140,
            height: 140,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFB0E2D5),
                width: 3,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  color: Color(0xFF0F6E56),
                  size: 40,
                ),
                SizedBox(height: 4),
                Text(
                  '24s',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F6E56),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Ürünü 24 saat beklet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF04342C),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Yarın tekrar baktığında hâlâ istiyorsan\nkararını yeniden değerlendirebilirsin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Color(0xFF085041),
            ),
          ),

          const SizedBox(height: 36),

          // 24 Saat Beklemeye Al Butonu
          CustomButton(
            text: '24 Saat Beklemeye Al',
            prefixIcon: Icons.eco_outlined,
            onPressed: onBeklemeyeEkle,
            backgroundColor: const Color(0xFF0F6E56),
            foregroundColor: Colors.white,
            height: 52,
            borderRadius: 16,
          ),

          const SizedBox(height: 12),

          // Vazgeçtim Butonu
          CustomButton(
            text: 'Vazgeçtim, ihtiyacım yokmuş',
            onPressed: onVazgec,
            backgroundColor: const Color(0xFFF4F8F5),
            foregroundColor: const Color(0xFF0F6E56),
            borderColor: const Color(0xFFD0E3DB),
            height: 52,
            borderRadius: 16,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
