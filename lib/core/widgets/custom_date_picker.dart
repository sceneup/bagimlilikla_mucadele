import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final String hintText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final IconData prefixIcon;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(String?)? validator;

  const CustomDatePicker({
    super.key,
    required this.hintText,
    required this.selectedDate,
    required this.onDateSelected,
    this.prefixIcon = Icons.calendar_today_outlined,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = selectedDate != null
        ? DateFormat('dd.MM.yyyy').format(selectedDate!)
        : '';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: enabled
          ? () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime(2000),
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime.now(),
          locale: const Locale('tr', 'TR'),
        );

        if (pickedDate != null) {
          onDateSelected?.call(pickedDate);
        }
      }
          : null,
      child: IgnorePointer(
        child: TextFormField(
          controller: TextEditingController(text: formattedDate),
          decoration: _buildDecoration(),
          validator: validator,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: AppColors.hint,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: AppColors.textSecondary,
      ),
      suffixIcon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textSecondary,
      ),
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