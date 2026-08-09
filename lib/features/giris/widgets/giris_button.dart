import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/giris/viewmodels/giris_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GirisButton extends ConsumerWidget {
  const GirisButton({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final vm = ref.read(girisViewModelProvider.notifier);
    return Column(
      spacing: 10,
      children: [
        CustomButton(
            text: "GİRİŞ",
            backgroundColor: AppColors.accent,
            fontSize: 20,
            height: 50,
            onPressed: () async{
              if (!vm.formKey.currentState!.validate()) {
                return;
              }

              final success = await ref
                  .read(girisViewModelProvider.notifier)
                  .login();

              if (success && context.mounted) {
                context.go("/anasayfa");
              }
            }
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            const Text("Hesabın yok mu?",
              style:TextStyle(color: AppColors.textSecondary,fontSize: 16) ,),
            TextButton(
              onPressed: (){
                context.go("/register");
              },
              child: const Text("Kayıt Ol",
                  style:TextStyle(color: AppColors.accent,fontSize: 18,fontWeight: FontWeight.bold)),
            ) ,
          ],
        )
      ],
    );
  }
}
