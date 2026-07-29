import 'package:bagimlilik/core/validators/app_validators.dart';
import 'package:bagimlilik/core/widgets/custom_date_picker.dart';
import 'package:bagimlilik/core/widgets/custom_dropdown.dart';
import 'package:bagimlilik/features/kayit/constants/kayit_dropdown_items.dart';
import 'package:bagimlilik/features/kayit/viewmodels/kayit_provider.dart';
import 'package:bagimlilik/features/kayit/widgets/girdi_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KayitDetayForm extends ConsumerWidget {
  const KayitDetayForm({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final vm = ref.read(kayitViewModelProvider.notifier);
    final state = ref.watch(kayitViewModelProvider);
    return Form(
      key: vm.detailFormKey,
      child: Column(
        spacing: 12,
        children: [
          GirdiField(
            label: "Doğum Tarihi",
            child: CustomDatePicker(
                hintText: "Doğum tarihinizi seçiniz",
                selectedDate: state.birthDate,
                onDateSelected: vm.setBirthDate,
              validator: (_) =>
                  AppValidators.minimumAge(state.birthDate),
            )
          ),
          GirdiField(
              label: "Cinsiyet",
              child: CustomDropdown(
                  hintText: "Cinsiyetinizi seçiniz",
                  items: KayitDropdownItems.genders
                       .map(
                      (gender) => DropdownMenuItem(
                          value: gender,
                           child: Text(gender),
                       ),
                  )
                    .toList(),
                onChanged: vm.setGender,
                validator: (value) =>
                    AppValidators.required(
                      value,
                      fieldName: "Cinsiyet",
                    ),
              )
          ),
          GirdiField(
              label: "Medeni Durum",
              child: CustomDropdown(
                hintText: "Medeni durumunuzu seçiniz",
                items: KayitDropdownItems.maritalStatus
                    .map(
                    (maritalstatus) => DropdownMenuItem(
                        value:maritalstatus,
                        child: Text(maritalstatus),
                    ),
                ).toList(),
                onChanged: vm.setMaritalStatus,
                validator: (value) =>
                    AppValidators.required(
                      value,
                      fieldName: "Medeni Durum",
                    ),
              )
          ),
          GirdiField(
              label: "Eğitim Durumu",
              child: CustomDropdown(
                hintText: "Eğitim durumunuzu seçiniz",
                items: KayitDropdownItems.educationLevels
                    .map(
                      (education) => DropdownMenuItem(
                    value:education,
                    child: Text(education),
                  ),
                ).toList(),
                onChanged: vm.setEducation,
                validator: (value) =>
                    AppValidators.required(
                      value,
                      fieldName: "Eğitim Durumu",
                    ),
              )
          ),
          GirdiField(
              label: "Meslek Durumu",
              child: CustomDropdown(
                hintText: "Meslek durumunuzu seçiniz",
                items: KayitDropdownItems.employmentStatus
                    .map(
                      (employment) => DropdownMenuItem(
                    value:employment,
                    child: Text(employment),
                  ),
                ).toList(),
                onChanged: vm.setEmploymentStatus,
                validator: (value) =>
                    AppValidators.required(
                      value,
                      fieldName: "Meslek Durumu",
                    ),
              )
          ),
          GirdiField(
              label: "Gelir Durumu",
              child: CustomDropdown(
                hintText: "Gelir durumunuzu seçiniz",
                items: KayitDropdownItems.incomeLevels
                    .map(
                      (income) => DropdownMenuItem(
                    value:income,
                    child: Text(income),
                  ),
                ).toList(),
                onChanged: vm.setIncomeLevel,
                validator: (value) =>
                    AppValidators.required(
                      value,
                      fieldName: "Gelir Durumu",
                    ),
              )
          ),
          GirdiField(
              label: "Telefon Süreniz",
              child: CustomDropdown(
                hintText: "Günlük telefon sürenizi seçiniz",
                items: KayitDropdownItems.phoneUsage
                    .map(
                      (phone) => DropdownMenuItem(
                    value:phone,
                    child: Text(phone),
                  ),
                ).toList(),
                onChanged: vm.setDailyPhoneUsage,
                validator: (value) =>
                    AppValidators.required(
                      value,
                      fieldName: "Telefon Süreniz",
                    ),
              )
          ),
        ],
      ),
    );
  }
}
