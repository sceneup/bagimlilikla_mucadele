import 'package:bagimlilik/features/profil/providers/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarActions extends ConsumerWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: profileAsync.when(
            data: (profile) {
              final avatar = profile?.avatar ?? '';

              if (avatar.isEmpty) {
                return const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person_outline),
                );
              }

              return CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(avatar),
              );
            },
            loading: () => const CircleAvatar(
              radius: 20,
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
            error: (_, __) => const CircleAvatar(
              radius: 20,
              child: Icon(Icons.person_outline),
            ),
          ),
        ),
      ],
    );
  }
}