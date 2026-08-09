import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final IconData? prefixIcon;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textSecondary,
      ),
      decoration: _buildDecoration(),
      dropdownColor: AppColors.secondaryContainer,
      borderRadius: BorderRadius.circular(20),
      menuMaxHeight: 280,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
      ),
      hint: Text(
        hintText,
        style: const TextStyle(
          color: AppColors.hint,
        ),
      ),
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      prefixIcon: prefixIcon != null
          ? Icon(
        prefixIcon,
        color: AppColors.textSecondary,
      )
          : null,
      filled: true,
      fillColor: AppColors.secondaryContainer,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      enabledBorder: _buildBorder(AppColors.border),
      focusedBorder: _buildBorder(AppColors.accent),
      errorBorder: _buildBorder(AppColors.error),
      focusedErrorBorder: _buildBorder(AppColors.error),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: color,
        width: 1.5,
      ),
    );
  }
}