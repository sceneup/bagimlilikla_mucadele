import 'package:flutter/material.dart';

class IndirimKart extends StatelessWidget {
  const IndirimKart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white,width: 2)
      ),
      child: Text("%65\n İNDİRİM",style: TextStyle(color: Colors.white,fontSize: 14),),
    );
  }
}
