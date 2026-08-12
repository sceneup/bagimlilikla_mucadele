import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/profil/providers/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilAvatarIsimBilgi extends ConsumerWidget {
  const ProfilAvatarIsimBilgi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilAsync = ref.watch(userProfileProvider);

    return profilAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),

      error: (error, stackTrace) => const Center(
        child: Text(
          'Profil bilgileri yüklenemedi.',
        ),
      ),

      data: (profil) {
        if (profil == null) {
          return const Center(
            child: Text(
              'Profil bulunamadı.',
            ),
          );
        }

        return Column(
          children: [
            // ==================================================
            // AVATAR
            // ==================================================

            GestureDetector(
              onTap: () {
                _avatarSec(
                  context,
                  ref,
                );
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor:
                    AppColors.secondaryContainer,
                    backgroundImage: profil.avatar.isNotEmpty
                        ? AssetImage(profil.avatar)
                        : null,
                    child: profil.avatar.isEmpty
                        ? const Icon(
                      Icons.person_outline,
                      size: 45,
                      color: AppColors.textSecondary,
                    )
                        : null,
                  ),

                  // Kalem butonu
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ==================================================
            // AD SOYAD
            // ==================================================

            Text(
              profil.fullName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 4),

            // ==================================================
            // EMAIL
            // ==================================================

            Text(
              profil.email,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // AVATAR SEÇ
  // ============================================================

  Future<void> _avatarSec(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final secilenAvatar = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const ProfilAvatarSecimBottomSheet();
      },
    );

    if (secilenAvatar == null) {
      return;
    }

    try {
      final basarili = await ref
          .read(userProfileProvider.notifier)
          .updateProfile(
        avatar: secilenAvatar,
      );

      if (!context.mounted) {
        return;
      }

      if (basarili) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Avatarın güncellendi.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Avatar güncellenemedi.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Avatar güncellenirken bir hata oluştu.',
          ),
        ),
      );
    }
  }
}

// ================================================================
// AVATAR SEÇİM BOTTOM SHEET
// ================================================================

class ProfilAvatarSecimBottomSheet extends StatelessWidget {
  const ProfilAvatarSecimBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ==================================================
            // BAŞLIK
            // ==================================================

            const Text(
              'Avatar Seç',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // AVATARLAR
            // ==================================================

            Expanded(
              child: GridView.builder(
                itemCount: 12,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final avatar =
                      'assets/images/avatars/avatar${index + 1}.JPG';

                  return InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {
                      Navigator.of(context).pop(
                        avatar,
                      );
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        avatar,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}