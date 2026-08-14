import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/odak_kontrolu/viewmodels/odak_kontrolu_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiyatAdimi extends ConsumerStatefulWidget {
  const FiyatAdimi({super.key});

  @override
  ConsumerState<FiyatAdimi> createState() => _FiyatAdimiState();
}

class _FiyatAdimiState extends ConsumerState<FiyatAdimi> {
  late final TextEditingController _fiyatController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(odakKontroluViewModelProvider);
    final initialFiyat = state.fiyat;
    _fiyatController = TextEditingController(
      text: (initialFiyat != null && initialFiyat > 0)
          ? initialFiyat.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _fiyatController.dispose();
    super.dispose();
  }

  void _devamEt() {
    ref
        .read(odakKontroluViewModelProvider.notifier)
        .fiyatMetniIleKaydet(_fiyatController.text);
  }

  void _atla() {
    ref.read(odakKontroluViewModelProvider.notifier).fiyatBelirle(null);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(odakKontroluViewModelProvider);
    final kategori = state.seciliKategori;
    final tetikleyici = state.seciliTetikleyici;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),

          // ============================================================
          // BAŞLIK VE AÇIKLAMA
          // ============================================================
          const Text(
            'Yaklaşık ne kadar?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF04342C),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bekleme listene eklemeden önce yaklaşık fiyatını bilmemiz yeterli.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Color(0xFF085041),
            ),
          ),

          const SizedBox(height: 24),

          // ============================================================
          // KATEGORİ VE TETİKLEYİCİ ÖZET KARTI
          // ============================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0x14000000),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kategori?.arkaplanRengi ?? const Color(0xFFE1F5EE),
                  ),
                  child: Icon(
                    kategori?.ikon ?? Icons.shopping_bag,
                    color: kategori?.simgeRengi ?? const Color(0xFF0F6E56),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kategori?.isim ?? 'Kategori',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF04342C),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tetikleyici != null
                            ? 'Seni tetikleyen: ${tetikleyici.isim}'
                            : 'Tetikleyici seçilmedi',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF085041),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ============================================================
          // FİYAT GİRİŞ KUTUSU
          // ============================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0x14000000),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '₺',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF04342C),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 180,
                  child: TextField(
                    controller: _fiyatController,
                    maxLines: 1,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _devamEt(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF04342C),
                    ),
                    decoration: const InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: Color(0xFFB0BEC5),
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ============================================================
          // YARDIMCI METİN VE ATLAMA LINKI
          // ============================================================
          const Text(
            'Tam fiyatı bilmiyorsan yaklaşık bir değer yazabilirsin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF085041),
            ),
          ),
          const SizedBox(height: 10),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _atla,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                'Fiyatı bilmiyorsan bu adımı atlayabilirsin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F6E56),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          const SizedBox(height: 36),


          CustomButton(
            text: 'Devam Et',
            onPressed: _devamEt,
            backgroundColor: const Color(0xFF0F6E56),
            foregroundColor: Colors.white,
            suffixIcon: Icons.arrow_forward,
            height: 52,
            fontSize: 17,
            borderRadius: 16,
          ),

          const SizedBox(height: 28),

          // ============================================================
          // DİPNOT AÇIKLAMASI
          // ============================================================
          const Text(
            'Fiyat bilgisi, bekleme sürecinden sonra kaçınılan potansiyel harcamayı ve tasarruf hedefindeki ilerlemeni göstermek için kullanılır.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              color: Color(0x73000000),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
