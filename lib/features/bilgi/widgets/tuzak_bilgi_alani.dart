import 'package:flutter/material.dart';
class TuzakBilgiAlani extends StatelessWidget {
  const TuzakBilgiAlani({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.visibility_off,size: 30,color: Colors.blue,),
          const SizedBox(width: 20,),
          Expanded(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Görünmez Tuzak",style: TextStyle(color: Colors.blueAccent,fontSize: 24),),
                  const SizedBox(height: 5,),
                  Text(
                      "Kırmızı renk ve büyük puntolar beyne tehlike sinyali göndererek hızlı karar vermeye zorlar.",
                      style: TextStyle(fontSize: 18),
                  ),
                ],
              ) 
          ),
        ],
      ),
    );
  }
}
