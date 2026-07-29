import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/giris/viewmodels/giris_provider.dart';
import 'package:bagimlilik/features/kayit/viewmodels/kayit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
            onPressed: (){
              if(vm.formKey.currentState!.validate()){
                EasyLoading.showSuccess("Giriş başarılı");

                Future.delayed(const Duration(seconds: 2), () {
                  context.go("/anasayfa");
                });
              }
              else{
                EasyLoading.showInfo(
                  "Lütfen hatalı alanları kontrol ediniz.",
                );
                return;
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
