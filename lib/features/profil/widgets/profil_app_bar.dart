import 'package:bagimlilik/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilAppBar extends ConsumerWidget {
  const ProfilAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        switch (value) {
          case 'account_settings':

            break;

          case 'logout':
            await _cikisYap(context, ref);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'account_settings',
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: 20,
              ),
              SizedBox(width: 12),
              Text('Hesap Ayarları'),
            ],
          ),
        ),

        const PopupMenuDivider(),

        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(
                Icons.logout_outlined,
                size: 20,
                color: Colors.red,
              ),
              SizedBox(width: 12),
              Text(
                'Çıkış Yap',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _cikisYap(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Çıkış Yap'),
          content: const Text(
            'Hesabından çıkış yapmak istediğine emin misin?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Çıkış Yap'),
            ),
          ],
        );
      },
    );

    if (onay != true) {
      return;
    }

    try {
      // 1. Supabase oturumunu kapat
      await ref.read(authServiceProvider).signOut();

      // 3. Login ekranına dön
      if (context.mounted) {
        context.go('/giris');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Çıkış yapılırken bir hata oluştu.',
            ),
          ),
        );
      }
    }
  }
}