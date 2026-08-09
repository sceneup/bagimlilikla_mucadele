import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class GirisBaslik extends StatelessWidget {
  const GirisBaslik({super.key});

  @override
  Widget build(BuildContext context) {
    double swidth = MediaQuery.sizeOf(context).width;

    return Column(
      spacing: 10,
      children: [
        SizedBox(height: swidth / 10),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const Text(
          "SIRIUS",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        const Text(
          "Tekrar Hoş Geldiniz\n"
              "Bugünkü hedeflerine devam etmeye hazır mısın?",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}