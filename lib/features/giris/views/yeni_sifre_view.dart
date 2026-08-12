import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/validators/app_validators.dart';
import 'package:bagimlilik/core/widgets/custom_text_fields.dart';
import 'package:bagimlilik/features/kayit/widgets/girdi_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class YeniSifreView extends ConsumerStatefulWidget {
  const YeniSifreView({super.key});

  @override
  ConsumerState<YeniSifreView> createState() => _YeniSifreViewState();
}

class _YeniSifreViewState extends ConsumerState<YeniSifreView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _sifreController;
  late final TextEditingController _sifreTekrarController;

  bool _yukleniyor = false;
  final bool _sifreGoster = false;
  final bool _sifreTekrarGoster = false;

  @override
  void initState() {
    super.initState();

    _sifreController = TextEditingController();
    _sifreTekrarController = TextEditingController();
  }

  @override
  void dispose() {
    _sifreController.dispose();
    _sifreTekrarController.dispose();
    super.dispose();
  }

  Future<void> _sifreyiGuncelle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_sifreController.text != _sifreTekrarController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Şifreler birbiriyle eşleşmiyor.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _yukleniyor = true;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: _sifreController.text,
        ),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Şifren başarıyla güncellendi.',
          ),
        ),
      );

      Navigator.of(context).pop();
    } on AuthException catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Şifre güncellenirken bir hata oluştu.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _yukleniyor = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryContainer2,
      appBar: AppBar(
        title: const Text(
          'Yeni Şifre',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.lock_reset_outlined,
                      size: 56,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      'Yeni Şifreni Belirle',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Center(
                    child: Text(
                      'Hesabın için yeni bir şifre oluştur.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  GirdiField(
                    label: 'Yeni Şifre',
                    child: CustomTextField(
                      controller: _sifreController,
                      hintText: 'Yeni şifrenizi girin',
                      prefixIcon: Icons.lock_outline,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_sifreGoster,
                      validator: AppValidators.password,
                    ),
                  ),

                  const SizedBox(height: 20),

                  GirdiField(
                    label: 'Yeni Şifre Tekrar',
                    child: CustomTextField(
                      controller: _sifreTekrarController,
                      hintText: 'Yeni şifrenizi tekrar girin',
                      prefixIcon: Icons.lock_outline,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_sifreTekrarGoster,
                      validator: (value) {
                        final passwordError =
                        AppValidators.password(value);

                        if (passwordError != null) {
                          return passwordError;
                        }

                        if (value != _sifreController.text) {
                          return 'Şifreler eşleşmiyor.';
                        }

                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _yukleniyor
                          ? null
                          : _sifreyiGuncelle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                      child: _yukleniyor
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        'Şifreyi Güncelle',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}