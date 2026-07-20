import 'package:flutter/material.dart';

class HemenAlButton extends StatelessWidget {
  const HemenAlButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black54,width: 2)
      ),
      child: Text("Hemen Satın Al",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
    );
  }
}
