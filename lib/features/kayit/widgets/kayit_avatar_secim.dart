import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/features/kayit/viewmodels/kayit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KayitAvatarSecim extends ConsumerWidget {
  const KayitAvatarSecim({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(kayitViewModelProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          builder: (_) => const AvatarBottomSheet(),
        );
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage(
              state.selectedAvatar,
            ),
          ),

          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
class AvatarBottomSheet extends ConsumerWidget {
  const AvatarBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final vm = ref.read(kayitViewModelProvider.notifier);

    return SizedBox(
      height: 350,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              "Avatar Seç",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

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
                      "assets/images/avatars/avatar${index + 1}.JPG";

                  return InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {

                      vm.setAvatar(avatar);

                      Navigator.pop(context);

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