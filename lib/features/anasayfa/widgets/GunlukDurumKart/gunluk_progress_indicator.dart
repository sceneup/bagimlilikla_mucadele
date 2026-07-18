import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class GunlukProgressIndicator extends StatelessWidget {
  final double value;
  const GunlukProgressIndicator({super.key,required this.value});

  @override
  Widget build(BuildContext context) {
    final percentage = (value * 100).toInt();

    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation(
                AppColors.accent,
              ),
              backgroundColor: Colors.white24,
              strokeCap: StrokeCap.round,
            ),
          ),
          Text(
            "$percentage%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
