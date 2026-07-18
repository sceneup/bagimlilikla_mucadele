import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const BottomBarItem({
        super.key,
        required this.icon,
        required this.label,
        required this.isSelected,
        required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
    ? AppColors.accent
        : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4,),
          Text(label,style: TextStyle(color: color ),),
        ],
      ),
    );
  }
}
