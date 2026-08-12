import 'package:bagimlilik/core/widgets/custom_app_bar.dart';
import 'package:bagimlilik/features/profil/providers/user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilView extends ConsumerWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Profilim",
      ),
      body: Column(),
    );
   }
}
