import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/kayit/viewmodels/kayit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
class DevamButton extends ConsumerWidget {
  const DevamButton({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final vm = ref.read(kayitViewModelProvider.notifier);
    return Column(
      spacing: 10,
      children: [
        CustomButton(
            text: "DEVAM EDİN",
            backgroundColor: AppColors.accent,
            fontSize: 20,
            height: 50,
            onPressed: () {
              if (vm.formKey.currentState!.validate()) {
                context.go("/detailregister");
              }
              else{
                EasyLoading.showInfo(
                  "Lütfen hatalı alanları kontrol ediniz.",
                );
              }
            }
        ),
        Row(
          spacing: 20,
          children: [
            const Text("zaten bir hesabın var mı?",
              style:TextStyle(color: AppColors.textSecondary,fontSize: 16) ,),
            TextButton(
              onPressed: (){
                context.go("/login");
              },
              child: const Text("Giriş Yap",
                style:TextStyle(color: AppColors.accent,fontSize: 18,fontWeight: FontWeight.bold)),
            ) ,
          ],
        )
      ],
    );
  }
}
