import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/custom_date_picker.dart';
import 'package:bagimlilik/core/widgets/custom_dropdown.dart';
import 'package:bagimlilik/features/kayit/constants/kayit_dropdown_items.dart';
import 'package:bagimlilik/features/profil/providers/user_profile_provider.dart';
import 'package:bagimlilik/features/profil/widgets/profil_hesap_bilgi_duzenleme.dart';
import 'package:bagimlilik/features/profil/widgets/profil_hesap_bilgi_satiri.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilHesapBilgileri extends ConsumerStatefulWidget {
  const ProfilHesapBilgileri({super.key});

  @override
  ConsumerState<ProfilHesapBilgileri> createState() =>
      _ProfilHesapBilgileriState();
}

class _ProfilHesapBilgileriState
    extends ConsumerState<ProfilHesapBilgileri> {
  String? _duzenlenenAlan;

  late final TextEditingController _usernameController;
  late final TextEditingController _fullNameController;

  String? _gender;
  String? _maritalStatus;
  String? _livingStatus;
  String? _educationLevel;
  String? _employmentStatus;

  DateTime? _birthDate;

  bool _kaydediliyor = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _fullNameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  // ============================================================
  // DÜZENLEMEYİ BAŞLAT
  // ============================================================

  void _duzenlemeyiBaslat(
      String alan,
      dynamic profil,
      ) {
    setState(() {
      _duzenlenenAlan = alan;

      switch (alan) {
        case 'username':
          _usernameController.text = profil.username;
          break;

        case 'full_name':
          _fullNameController.text = profil.fullName;
          break;

        case 'birthDate':
          _birthDate = profil.birthDate;
          break;

        case 'gender':
          _gender = profil.gender;
          break;

        case 'maritalStatus':
          _maritalStatus = profil.maritalStatus;
          break;

        case 'educationLevel':
          _educationLevel = profil.educationLevel;
          break;

        case 'employmentStatus':
          _employmentStatus = profil.employmentStatus;
          break;

        case 'livingStatus':
          _livingStatus = profil.livingStatus;
          break;
      }
    });
  }

  // ============================================================
  // İPTAL
  // ============================================================

  void _iptal() {
    setState(() {
      _duzenlenenAlan = null;
      _kaydediliyor = false;
    });
  }

  // ============================================================
  // KAYDET
  // ============================================================

  Future<void> _kaydet(String alan) async {
    setState(() {
      _kaydediliyor = true;
    });

    bool basarili = false;

    try {
      final notifier =
      ref.read(userProfileProvider.notifier);

      switch (alan) {
        case 'username':
          basarili = await notifier.updateProfile(
            username: _usernameController.text.trim(),
          );
          break;

        case 'full_name':
          basarili = await notifier.updateProfile(
            fullName: _fullNameController.text.trim(),
          );
          break;

        case 'birthDate':
          if (_birthDate == null) {
            break;
          }

          basarili = await notifier.updateProfile(
            birthDate: _birthDate,
          );
          break;

        case 'gender':
          basarili = await notifier.updateProfile(
            gender: _gender,
          );
          break;

        case 'maritalStatus':
          basarili = await notifier.updateProfile(
            maritalStatus: _maritalStatus,
          );
          break;

        case 'educationLevel':
          basarili = await notifier.updateProfile(
            educationLevel: _educationLevel,
          );
          break;

        case 'employmentStatus':
          basarili = await notifier.updateProfile(
            employmentStatus: _employmentStatus,
          );
          break;

        case 'livingStatus':
          basarili = await notifier.updateProfile(
            livingStatus: _livingStatus,
          );
          break;
      }

      if (!mounted) return;

      if (basarili) {
        setState(() {
          _duzenlenenAlan = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profil bilgilerin güncellendi.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profil güncellenemedi.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profil güncellenirken bir hata oluştu.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _kaydediliyor = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final profilAsync = ref.watch(userProfileProvider);

    return profilAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => const Center(
        child: Text(
          'Profil bilgileri yüklenemedi.',
        ),
      ),
      data: (profil) {
        if (profil == null) {
          return const Center(
            child: Text(
              'Profil bulunamadı.',
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hesap Bilgileri',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
                  _fullname(profil),

                  const _Ayirici(),
                  _username(profil),
                  const _Ayirici(),

                  _birthDateField(profil),
                  const _Ayirici(),

                  _dropdownField(
                    alan: 'gender',
                    icon: Icons.wc_outlined,
                    baslik: 'Cinsiyet',
                    deger: profil.gender ?? '-',
                    secilenDeger: _gender,
                    secenekler: KayitDropdownItems.genders,
                    profil: profil,
                  ),

                  const _Ayirici(),

                  _dropdownField(
                    alan: 'maritalStatus',
                    icon: Icons.favorite_border,
                    baslik: 'Medeni Durum',
                    deger: profil.maritalStatus ?? '-',
                    secilenDeger: _maritalStatus,
                    secenekler:
                    KayitDropdownItems.maritalStatus,
                    profil: profil,
                  ),

                  const _Ayirici(),

                  _dropdownField(
                    alan: 'educationLevel',
                    icon: Icons.school_outlined,
                    baslik: 'Eğitim',
                    deger: profil.educationLevel ?? '-',
                    secilenDeger: _educationLevel,
                    secenekler:
                    KayitDropdownItems.educationLevels,
                    profil: profil,
                  ),

                  const _Ayirici(),

                  _dropdownField(
                    alan: 'employmentStatus',
                    icon: Icons.work_outline,
                    baslik: 'Çalışma Durumu',
                    deger:
                    profil.employmentStatus ?? '-',
                    secilenDeger: _employmentStatus,
                    secenekler:
                    KayitDropdownItems.employmentStatus,
                    profil: profil,
                  ),

                  const _Ayirici(),

                  _dropdownField(
                    alan: 'livingStatus',
                    icon: Icons.family_restroom,
                    baslik: 'Yaşama Durumu',
                    deger: profil.livingStatus ?? '-',
                    secilenDeger: _livingStatus,
                    secenekler:
                    KayitDropdownItems.livingStatus,
                    profil: profil,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  Widget _fullname(dynamic profil) {
    if (_duzenlenenAlan != 'full_name') {
      return ProfilHesapBilgiSatiri(
        icon: Icons.person,
        baslik: 'Ad Soyad',
        deger: profil.fullName,
        onEdit: () {
          _duzenlemeyiBaslat(
            'full_name',
            profil,
          );
        },
      );
    }

    return ProfilHesapBilgiDuzenleme(
      icon: Icons.person,
      baslik: 'Ad Soyad',
      onCancel: _iptal,
      onSave: () => _kaydet('full_name'),
      loading: _kaydediliyor,
      child: TextField(
        controller: _fullNameController,
        enabled: !_kaydediliyor,
        textCapitalization: TextCapitalization.words,
        decoration: _inputDecoration(
          'Ad soyadınızı girin',
        ),
      ),
    );
  }
  // ============================================================
  // KULLANICI ADI
  // ============================================================

  Widget _username(dynamic profil) {
    if (_duzenlenenAlan != 'username') {
      return ProfilHesapBilgiSatiri(
        icon: Icons.person_outline,
        baslik: 'Kullanıcı Adı',
        deger: profil.username,
        onEdit: () {
          _duzenlemeyiBaslat(
            'username',
            profil,
          );
        },
      );
    }

    return ProfilHesapBilgiDuzenleme(
      icon: Icons.person_outline,
      baslik: 'Kullanıcı Adı',
      onCancel: _iptal,
      onSave: () => _kaydet('username'),
      loading: _kaydediliyor,
      child: TextField(
        controller: _usernameController,
        enabled: !_kaydediliyor,
        decoration: _inputDecoration(
          'Kullanıcı adınızı girin',
        ),
      ),
    );
  }

  // ============================================================
  // DOĞUM TARİHİ
  // ============================================================

  Widget _birthDateField(dynamic profil) {
    if (_duzenlenenAlan != 'birthDate') {
      return ProfilHesapBilgiSatiri(
        icon: Icons.cake_outlined,
        baslik: 'Doğum Tarihi',
        deger: _dogumTarihiFormatla(
          profil.birthDate,
        ),
        onEdit: () {
          _duzenlemeyiBaslat(
            'birthDate',
            profil,
          );
        },
      );
    }

    return ProfilHesapBilgiDuzenleme(
      icon: Icons.cake_outlined,
      baslik: 'Doğum Tarihi',
      onCancel: _iptal,
      onSave: () => _kaydet('birthDate'),
      loading: _kaydediliyor,
      child: CustomDatePicker(
        hintText: 'Doğum tarihinizi seçiniz',
        selectedDate: _birthDate,
        onDateSelected: (date) {
          setState(() {
            _birthDate = date;
          });
        },
      ),
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget _dropdownField({
    required String alan,
    required IconData icon,
    required String baslik,
    required String deger,
    required String? secilenDeger,
    required List<String> secenekler,
    required dynamic profil,
  }) {
    if (_duzenlenenAlan != alan) {
      return ProfilHesapBilgiSatiri(
        icon: icon,
        baslik: baslik,
        deger: deger,
        onEdit: () {
          _duzenlemeyiBaslat(
            alan,
            profil,
          );
        },
      );
    }

    return ProfilHesapBilgiDuzenleme(
      icon: icon,
      baslik: baslik,
      onCancel: _iptal,
      onSave: () => _kaydet(alan),
      loading: _kaydediliyor,
      child: CustomDropdown(
        hintText: baslik,
        value: secilenDeger,
        items: secenekler
            .map(
              (secenek) => DropdownMenuItem<String>(
            value: secenek,
            child: Text(secenek),
          ),
        )
            .toList(),
        onChanged: _kaydediliyor
            ? null
            : (value) {
          final selectedValue =
          value as String?;

          setState(() {
            switch (alan) {
              case 'gender':
                _gender = selectedValue;
                break;

              case 'maritalStatus':
                _maritalStatus =
                    selectedValue;
                break;

              case 'educationLevel':
                _educationLevel =
                    selectedValue;
                break;

              case 'employmentStatus':
                _employmentStatus =
                    selectedValue;
                break;

              case 'livingStatus':
                _livingStatus =
                    selectedValue;
                break;
            }
          });
        },
      ),
    );
  }

  // ============================================================
  // INPUT
  // ============================================================

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.secondaryContainer2,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  // ============================================================
  // TARİH FORMAT
  // ============================================================

  String _dogumTarihiFormatla(DateTime? tarih) {
    if (tarih == null) {
      return '-';
    }

    return '${tarih.day.toString().padLeft(2, '0')}.'
        '${tarih.month.toString().padLeft(2, '0')}.'
        '${tarih.year}';
  }
}

// ================================================================
// AYIRICI
// ================================================================

class _Ayirici extends StatelessWidget {
  const _Ayirici();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 42),
      child: Divider(
        height: 1,
        thickness: 1,
      ),
    );
  }
}