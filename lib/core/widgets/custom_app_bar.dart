import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String title;
  final bool centerTitle;

  final Widget? leading;

  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,style: TextStyle(color: AppColors.primary,fontWeight: FontWeight.bold),),
      elevation: 0.5,
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      backgroundColor: AppColors.secondaryContainer2,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}