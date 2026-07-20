import 'package:flutter/material.dart';

class ZamanKartAlani extends StatelessWidget {
  const ZamanKartAlani({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red,width: 3),
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(16),    
      ),
      child: Column(
        children: [
          const Row(
            children: [
              const Text("Kalan Süre",style: TextStyle(color: Colors.brown,fontSize: 20),),
              const Spacer(),
              const Text("Durum",style: TextStyle(color: Colors.brown,fontSize: 20),),
            ],
          ),
          const SizedBox(height: 5,),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child:const Text("00:10:12",style: TextStyle(color: Colors.red,fontSize: 20),)),
              const Text("Stokta son 3 ürün kaldı!",style: TextStyle(color: Colors.red,fontSize: 16),),
            ],
          )
        ],
      ),
    );
  }
}
