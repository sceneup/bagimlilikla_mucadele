import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/kayit/viewmodels/kayit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KvvkOnam extends ConsumerStatefulWidget {
  const KvvkOnam({super.key});

  @override
  ConsumerState<KvvkOnam> createState() => _KvvkOnamState();
}

class _KvvkOnamState extends ConsumerState<KvvkOnam> {
  bool kvkkOnay = false;
  bool onamOnay = false;

  void _kontrolEt() {
    final tamamlandi = kvkkOnay && onamOnay;

    ref
        .read(kayitViewModelProvider.notifier)
        .setOnamlarTamam(tamamlandi);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          value: kvkkOnay,
          onChanged: (value) {
            setState(() {
              kvkkOnay = value ?? false;
            });

            _kontrolEt();
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.accent,
          title: GestureDetector(
            onTap: () {
              _kvkkMetniniGoster(context);
            },
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'KVKK Aydınlatma Metni',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: '\'ni okudum ve bilgilendirildim.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        CheckboxListTile(
          value: onamOnay,
          onChanged: (value) {
            setState(() {
              onamOnay = value ?? false;
            });

            _kontrolEt();
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.accent,
          title: GestureDetector(
            onTap: () {
              _onamMetniniGoster(context);
            },
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Açık Rıza Metni',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: '\'ni okudum ve kabul ediyorum.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _kvkkMetniniGoster(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'KVKK Aydınlatma Metni',
          ),
          content: const SingleChildScrollView(
            child: Text(
              'Buraya KVKK Aydınlatma Metniniz gelecek.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  void _onamMetniniGoster(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Açık Rıza Metni',
          ),
          content: const SingleChildScrollView(
            child: Text(
              'Buraya Açık Rıza / Onam Metniniz gelecek.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }
}