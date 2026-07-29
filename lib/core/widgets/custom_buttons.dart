import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  /// Durum
  final bool isLoading;
  final bool enabled;

  /// Görünüm
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double height;
  final double? width;
  final double elevation;

  /// İçerik
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,

    this.isLoading = false,
    this.enabled = true,

    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,

    this.borderRadius = 16,
    this.height = 54,
    this.width,

    this.elevation = 0,

    this.prefixIcon,
    this.suffixIcon,

    this.iconSize = 20,

    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.accent;
    final fgColor = foregroundColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: (!enabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: elevation,
          disabledBackgroundColor: bgColor.withValues(alpha: .5),
          disabledForegroundColor: fgColor.withValues(alpha: .8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: fgColor,
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, size: iconSize),
              const SizedBox(width: 8),
            ],

            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),

            if (suffixIcon != null) ...[
              const SizedBox(width: 8),
              Icon(suffixIcon, size: iconSize),
            ],
          ],
        ),
      ),
    );
  }
}