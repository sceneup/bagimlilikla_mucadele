import 'package:bagimlilik/features/anket/widgets/anketcard/anket_cevaplar.dart';
import 'package:flutter/material.dart';

class AnketSoruCard extends StatelessWidget {
  final int soruNo;
  final String soruMetni;

  const AnketSoruCard({
    required this.soruNo,
    required this.soruMetni,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
              "$soruNo. $soruMetni",
              style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),),
             AnketCevaplar(
               seciliDeger: 1,
               onChanged: (value) {
               debugPrint(value.toString());
             },),
        ],
      ),
    );
  }
}
