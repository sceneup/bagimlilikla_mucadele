import 'package:flutter/material.dart';
import 'package:bagimlilik/core/colors/app_colors.dart';
class HedefKartBaslik extends StatelessWidget {
  const HedefKartBaslik({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tasarruf Hedefin",style: TextStyle(color: AppColors.primary,fontSize: 18),),
                  Text("Yeni Bilgisayar",style: TextStyle(fontSize: 24),),
                ],
              ),
            ),
            Icon(Icons.laptop,size: 40,color: AppColors.accent,),
            const SizedBox(width: 10,),
          ],
        ),
        const SizedBox(height: 8,),
        Row(
          children: [
            Text("3.500₺",style: TextStyle(fontWeight: FontWeight.bold),),
            Spacer(),
            Text("15.000₺",style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
      ],
    );
  }
}
