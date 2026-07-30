import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class GirdiField extends StatelessWidget {
  final String label;
  final Widget child;

  const GirdiField({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: const TextStyle(
                color: AppColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            )
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}