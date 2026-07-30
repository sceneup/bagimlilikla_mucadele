import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_buttons.dart';
import 'package:bagimlilik/features/kayit/viewmodels/kayit_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
class KayitOlButton extends ConsumerWidget {
  const KayitOlButton({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final vm = ref.read(kayitViewModelProvider.notifier);
    return Column(
      spacing: 10,
      children: [
        CustomButton(
            text: "KAYIT OL",
            backgroundColor: AppColors.accent,
            fontSize: 20,
            height: 50,
            onPressed: (){
               if(vm.detailFormKey.currentState!.validate()){

               }
               else{
                 EasyLoading.showInfo(
                   "Lütfen hatalı alanları kontrol ediniz.",
                 );
                 return;
               }
            }
        ),
        TextButton(onPressed: (){
          context.go("/register");
        },
            child: Text("Geri",style: const TextStyle(color: AppColors.accent,fontSize: 20),))
      ],
    );
  }
}
