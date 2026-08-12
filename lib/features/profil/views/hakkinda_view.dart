import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HakkindaView extends StatelessWidget {
  const HakkindaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: CustomAppBar(
        title: 'Hakkında',
        leading: IconButton(
            onPressed: (){
              context.go("/profil");
            },
            icon: const Icon(Icons.arrow_back)
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: AppColors.accent),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent
                      )
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 30,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Sirius',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Daha bilinçli alışveriş,\ndaha özgür kararlar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Sirius, çevrimiçi alışveriş sırasında daha '
                        'bilinçli kararlar vermene yardımcı olmak için '
                        'tasarlanmış bir farkındalık uygulamasıdır. '
                        'Alışveriş isteği oluştuğunda kısa bir duraklama '
                        'alanı sunar ve kararını yeniden değerlendirmeni '
                        'destekler.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Sirius ile Neler Yapabilirsin?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _OzellikSatiri(
                    icon: Icons.shopping_bag_outlined,
                    text: 'Alışveriş dürtülerini fark edebilirsin.',
                  ),

                  const _Ayirici(),

                  _OzellikSatiri(
                    icon: Icons.hourglass_empty,
                    text: 'İhtiyaçlarını değerlendirmek için '
                        'bekleme listesi oluşturabilirsin.',
                  ),

                  const _Ayirici(),

                  _OzellikSatiri(
                    icon: Icons.flag_outlined,
                    text: 'Tasarruf hedefleri belirleyebilirsin.',
                  ),

                  const _Ayirici(),

                  _OzellikSatiri(
                    icon: Icons.notifications_none_outlined,
                    text: 'Alışveriş sırasında farkındalık '
                        'bildirimleri alabilirsin.',
                  ),

                  const _Ayirici(),

                  _OzellikSatiri(
                    icon: Icons.self_improvement_outlined,
                    text: 'Satın alma kararını yeniden '
                        'değerlendirebilirsin.',
                  ),

                  const _Ayirici(),

                  _OzellikSatiri(
                    icon: Icons.bar_chart_outlined,
                    text: 'Alışveriş davranışındaki gelişimini '
                        'takip edebilirsin.',
                  ),

                  const _Ayirici(),

                  _OzellikSatiri(
                    icon: Icons.menu_book_outlined,
                    text: 'Bilinçli alışveriş ve davranışsal '
                        'farkındalık hakkında bilgi edinebilirsin.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Center(
              child: Column(
                children: [
                  Text(
                    'Daha bilinçli alışveriş, daha özgür kararlar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Sirius · Sürüm 1.0.0',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OzellikSatiri extends StatelessWidget {
  final IconData icon;
  final String text;

  const _OzellikSatiri({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.textSecondary,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ayirici extends StatelessWidget {
  const _Ayirici();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 0.5,
      indent: 48,
      endIndent: 12,
    );
  }
}