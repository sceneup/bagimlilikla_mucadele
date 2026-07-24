import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AnketCevaplar extends StatelessWidget {
  final int? seciliDeger;
  final ValueChanged<int?> onChanged;

  const AnketCevaplar({
    required this.seciliDeger,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const cevaplar = [
      "Hiçbir zaman",
      "Nadiren",
      "Bazen",
      "Sık sık",
      "Her zaman",
    ];
    return RadioGroup<int>(
      groupValue: seciliDeger,
      onChanged: onChanged,
      child: Row(
        children: List.generate(
          cevaplar.length,
              (index) {
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: 1.3,
                    child: Radio<int>(
                      value: index,
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.accent;
                        }

                        return Colors.grey;
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child: Text(
                      cevaplar[index],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
