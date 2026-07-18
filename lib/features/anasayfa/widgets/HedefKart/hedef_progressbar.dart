import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class HedefProgressbar extends StatelessWidget {
  const HedefProgressbar({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: 0.20,
      minHeight: 10,
      borderRadius: BorderRadius.circular(16),
      color: AppColors.primary,
      backgroundColor: AppColors.secondaryContainer,
    );
  }
}
