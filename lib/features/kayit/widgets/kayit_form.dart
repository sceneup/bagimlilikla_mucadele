import 'package:bagimlilik/core/validators/app_validators.dart';
import 'package:bagimlilik/core/widgets/custom_text_fields.dart';
import 'package:bagimlilik/features/kayit/viewmodels/kayit_provider.dart';
import 'package:bagimlilik/features/kayit/widgets/girdi_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KayitForm extends ConsumerWidget {
  const KayitForm({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final vm = ref.read(kayitViewModelProvider.notifier);
    return Form(
      key: vm.formKey,
      child: Column(
        spacing: 12,
        children: [
          GirdiField(
            label: "Ad Soyad",
            child: CustomTextField(
              controller: vm.adsoyadController,
              hintText: "Adınızı ve soyadınızı girin",
              prefixIcon: Icons.person_outline,
              validator: (value) =>
                  AppValidators.required(
                    value,
                    fieldName: "Ad Soyad",
                  ),
            ),
          ),
          GirdiField(
            label: "Kullanıcı Adı",
            child: CustomTextField(
              controller: vm.kullaniciAdiController,
              hintText: "Kullanıcı adınızı girin",
              prefixIcon: Icons.alternate_email,
              validator: (value) =>
                  AppValidators.required(
                    value,
                    fieldName: "Kullanıcı Adı"
                  ),
            ),
          ),
          GirdiField(
            label: "E-Posta",
            child: CustomTextField(
              controller: vm.emailController,
              hintText: "E-Postanızı girin",
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  AppValidators.email(
                    value,
                  ),
            ),
          ),
          GirdiField(
            label: "Şifre",
            child: CustomTextField(
              controller: vm.sifreController,
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
          GirdiField(
            label: "Tekrar Şifre",
            child: CustomTextField(
              controller: vm.sifreTekrarController,
              hintText: "Şifreyi tekrar girin",
              prefixIcon: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (value) =>
                  AppValidators.confirmPassword(
                    value,
                    vm.sifreController.text,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
