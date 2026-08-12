import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class ProfilHesapBilgiDuzenleme extends StatelessWidget {
  final IconData icon;
  final String baslik;
  final Widget child;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool loading;

  const ProfilHesapBilgiDuzenleme({
    super.key,
    required this.icon,
    required this.baslik,
    required this.child,
    required this.onCancel,
    required this.onSave,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: AppColors.primary,
              ),

              const SizedBox(width: 10),

              Text(
                baslik,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          child,

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: loading ? null : onCancel,
                child: const Text('İptal'),
              ),

              const SizedBox(width: 8),

              FilledButton.icon(
                onPressed: loading ? null : onSave,
                icon: loading
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(
                  Icons.check,
                  size: 18,
                ),
                label: const Text('Kaydet'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}