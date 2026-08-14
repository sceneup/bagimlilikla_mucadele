import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/odak_kontrolu/models/odak_kontrolu_state.dart';
import 'package:bagimlilik/features/odak_kontrolu/viewmodels/odak_kontrolu_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IstekSeviyesiSayfasi extends ConsumerWidget {
  final OdakKontroluState state;
  final VoidCallback onDevamEt;

  const IstekSeviyesiSayfasi({
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
            'Şu an ne kadar istiyorsun?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F6E56),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Bu ürünü alma isteğin ne kadar güçlü?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF085041),
            ),
          ),

          const SizedBox(height: 28),

          // Slider Kartı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x14000000)),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sadece\naklımdan\ngeçiyor',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: Color(0xFF085041),
                      ),
                    ),
                    Text(
                      'Çok istiyorum',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF085041),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF0F6E56),
                    inactiveTrackColor: const Color(0xFFE0EFEA),
                    thumbColor: const Color(0xFF1976D2),
                    overlayColor: const Color(0x291976D2),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 10),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: state.istekSeviyesi.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (val) {
                      viewModel.istekSeviyesiGuncelle(val.round());
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // 1 2 3 4 5 Rakamları
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final numVal = index + 1;
                    return Text(
                      '$numVal',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: state.istekSeviyesi == numVal
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: state.istekSeviyesi == numVal
                            ? const Color(0xFF0F6E56)
                            : const Color(0xFF7A9E96),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'İsteğinin ne kadar güçlü olduğunu fark ettin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF085041),
            ),
          ),

          const SizedBox(height: 36),

          CustomButton(
            text: 'Devam',
            suffixIcon: Icons.arrow_forward,
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
