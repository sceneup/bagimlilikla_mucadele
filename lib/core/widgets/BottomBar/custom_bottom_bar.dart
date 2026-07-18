import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:bagimlilik/core/widgets/BottomBar/bottom_bar_item.dart';
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
              child: BottomBarItem(
                icon: Icons.home,
                label: 'Anasayfa',
                isSelected: currentIndex == 0,
                onTap: () => onItemSelected(0),
              )
          ),
          Expanded(
              child: BottomBarItem(
                icon: Icons.info,
                label: 'Bilgi',
                isSelected: currentIndex == 1,
                onTap: () => onItemSelected(1),
              )
          ),
          SizedBox(width: 72,),
          Expanded(
              child: BottomBarItem(
                icon: Icons.auto_graph,
                label: 'Analiz',
                isSelected: currentIndex == 2,
                onTap: () => onItemSelected(2),
              )
          ),
          Expanded(
              child: BottomBarItem(
                icon: Icons.person,
                label: 'Profil',
                isSelected: currentIndex == 3,
                onTap: () => onItemSelected(3),
              )
          ),
        ],
      ),
    );
  }
}
