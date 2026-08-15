import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/BottomBar/custom_bottom_bar.dart';
import 'package:bagimlilik/features/bekleme_listesi/services/bildirim_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BildirimService().baslat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: widget.navigationShell.currentIndex,
        onItemSelected: (index) {
          widget.navigationShell.goBranch(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/odak-kontrolu'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
    );
  }
}