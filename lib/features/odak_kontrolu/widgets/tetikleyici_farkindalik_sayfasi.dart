import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/odak_kontrolu_state.dart';
import 'package:flutter/material.dart';

class TetikleyiciFarkindalikSayfasi extends StatelessWidget {
  final OdakKontroluState state;
  final VoidCallback onDevamEt;

  const TetikleyiciFarkindalikSayfasi({
    required this.state,
    required this.onDevamEt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tetikleyici = state.seciliTetikleyici;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.search,
                color: Color(0xFF0F6E56),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Seni buraya getiren şey',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F6E56),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Tetikleyici Kartı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0x14000000)),
            ),
            child: Text(
              tetikleyici?.isim ?? 'Belirtilmedi',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF04342C),
              ),
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            'Bunu fark etmen önemli.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF085041),
            ),
          ),

          const SizedBox(height: 48),

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
