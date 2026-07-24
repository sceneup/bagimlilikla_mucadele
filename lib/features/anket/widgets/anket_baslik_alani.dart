import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AnketBaslikAlani extends StatelessWidget {
  double value;
  AnketBaslikAlani({required this.value,super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8,),
            LinearProgressIndicator(
              color: AppColors.accent,
              backgroundColor: AppColors.primaryContainer,
              minHeight: 8,
              value: value,
            ),
            const SizedBox(height: 16,),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/anketresim.png",
                    fit: BoxFit.cover,
                  ),
                ),

                // Hafif koyu katman
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.10),
                    ),
                  ),
                ),

                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Text(
                    "Alışveriş Alışkanlıklarınızı\nDeğerlendirelim",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 8,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6,),
            const Text("bu test 3 dakika sürer ve deneyiminizi kişiselleştirmemize yardımcı olur",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,)
          ],
    );
  }
}
