import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/odak_kontrolu_state.dart';
import 'package:bagimlilik/features/odak_kontrolu/viewmodels/odak_kontrolu_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UrunAnlamiSayfasi extends ConsumerWidget {
  final OdakKontroluState state;
  final VoidCallback onDevamEt;

  static const List<String> _urunAnlamiSecenekleri = [
    'Gerçekten ihtiyacım var',
    'Kendimi iyi hissettirecek',
    'Hoşuma gitti, sahip olmak istiyorum',
    'Emin değilim',
  ];

  const UrunAnlamiSayfasi({
    required this.state,
    required this.onDevamEt,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(odakKontroluViewModelProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          const Text(
            'Biraz daha düşünelim.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F6E56),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Bu ürün şu anda senin için daha çok ne ifade ediyor?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Color(0xFF085041),
            ),
          ),

          const SizedBox(height: 24),

          // 4 Seçenek Listesi
          Column(
            children: _urunAnlamiSecenekleri.map((secenek) {
              final isSelected = state.urunAnlami == secenek;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => viewModel.urunAnlamiSec(secenek),
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE1F5EE)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0F6E56)
                            : const Color(0x14000000),
                        width: isSelected ? 1.8 : 1.0,
                      ),
                    ),
                    child: Text(
                      secenek,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF0F6E56)
                            : const Color(0xFF04342C),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

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
