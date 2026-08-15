import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/notification/providers/notification_provider.dart';
import 'package:bagimlilik/features/notification/widgets/bildirim_aciklama.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final state =
    ref.watch(notificationViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: CustomAppBar(
        title: "Sirius",
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,left: 16.0),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/images/img.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              BildirimAciklama(),
              const Spacer(),
              if (state.hasPermission)
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [

                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Bildirim erişimi aktif",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child:CustomButton(
                    backgroundColor: AppColors.green,
                    text: "Bildirim Erişimini Aç",
                    onPressed: () {
                      ref
                          .read(
                        notificationViewModelProvider
                            .notifier,
                      )
                          .enableNotifications();
                    },
                  ),
                ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: CustomButton(
                  backgroundColor: state.hasPermission
                      ? AppColors.green
                      : AppColors.border,
                  foregroundColor: state.hasPermission
                      ? Colors.white
                      : AppColors.textSecondary,
                  text: "Uygulamaya Devam Et",
                  onPressed: state.hasPermission
                      ? () async {
                    try {
                      final vm = ref.read(
                        notificationViewModelProvider.notifier,
                      );

                      await vm.confirmNotificationAccess();

                      if (!context.mounted) return;

                      context.go("/anasayfa");
                    } catch (e) {
                      debugPrint(
                        'Bildirim erişimi kaydedilemedi: $e',
                      );
                    }
                  }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
