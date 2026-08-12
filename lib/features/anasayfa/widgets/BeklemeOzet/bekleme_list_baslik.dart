import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BeklemeListBaslik extends StatelessWidget {
  const BeklemeListBaslik({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Bekleme Listem", style: TextStyle(fontSize: 24)),
        const Spacer(),
        GestureDetector(
          onTap: () => context.push('/bekleme-listesi'),
          child: const Text(
            "Tümünü Gör",
            style: TextStyle(color: AppColors.accent, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
