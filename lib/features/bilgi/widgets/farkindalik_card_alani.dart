import 'package:bagimlilik/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

class FarkindalikCardAlani extends StatelessWidget {
  const FarkindalikCardAlani({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
       color: AppColors.blue,
       borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.lightbulb,size: 25,color: Colors.blueAccent,),
              ),
              const SizedBox(width: 10,),
              const Text("Bu Bir Psikolojik Tetikleyici",style: TextStyle(color: Colors.white,fontSize: 20),)
            ],
          ),
          const SizedBox(height: 16,),
          Text(
            "Geri sayım sayaçları ve 'son ürün' gibi mesajlar, ikna edici tasarım (persuasive design) teknikleridir. Bu yöntemler, aciliyet hissi yaratarak rasyonel düşünmeyi engeller ve dürtüsel alışveriş yapma olasılığınızı artırır.",
             style: TextStyle(fontSize: 18,),textAlign: TextAlign.justify
          )
        ],
      ),
    );
  }
}
