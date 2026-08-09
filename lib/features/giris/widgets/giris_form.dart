import 'package:bagimlilik/core/validators/app_validators.dart';
import 'package:bagimlilik/core/widgets/custom_text_fields.dart';
import 'package:bagimlilik/features/giris/viewmodels/giris_provider.dart';
import 'package:bagimlilik/features/giris/widgets/giris_button.dart';
import 'package:bagimlilik/features/kayit/widgets/girdi_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bagimlilik/core/colors/app_colors.dart';

class GirisForm extends ConsumerWidget {
  const GirisForm({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final vm = ref.read(girisViewModelProvider.notifier);
    return Form(
      key: vm.formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            GirdiField(
              label: "Kullanıcı Adı",
              child: CustomTextField(
                controller: vm.usernameController,
                hintText: "Kullanıcı adınızı girin",
                prefixIcon: Icons.alternate_email,
                validator: (value) =>
                    AppValidators.required(
                        value,
                        fieldName: "Kullanıcı Adı"
                    ),
              ),
            ),
            const SizedBox(height: 20,),
            GirdiField(
              label: "Şifre",
              child: CustomTextField(
                controller: vm.passwordController,
                hintText: "Şifre oluşturun",
                prefixIcon: Icons.lock_outline,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validator: (value) =>
                    AppValidators.password(
                      value,
                    ),
              ),
            ),
            Row(
              children: [
                Spacer(),
                TextButton(
                    onPressed: (){},
                    child: const Text("Şifremi unuttum",style: TextStyle(color: AppColors.accent,fontSize: 14),)
                ),
              ],
            ),
            const SizedBox(height: 20,),
            GirisButton(),
          ],
        ),
      ),
    );
  }
}
