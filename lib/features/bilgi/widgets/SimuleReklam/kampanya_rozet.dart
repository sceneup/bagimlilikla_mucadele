import 'package:flutter/material.dart';

class KampanyaRozet extends StatelessWidget {
  const KampanyaRozet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text("Sadece Sana Özel Fırsat",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
    );
  }
}
