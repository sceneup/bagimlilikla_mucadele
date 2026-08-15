import 'package:flutter/material.dart';

class BildirimAciklama extends StatelessWidget {
  const BildirimAciklama({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 27,
              color: Colors.black87,
            ),
            SizedBox(width: 10),
            Text(
              "Bildirim Erişimi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Text(
          "Sirius, danışmanınız tarafından belirlenen "
              "farkındalık ve müdahale bildirimlerini, "
              "mesajları ve diğer önemli bildirimleri "
              "analiz ederek size zamanında destek sunar.",
          style: TextStyle(
            fontSize: 16,
            height: 1.55,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          "Uygulamanın planlanan müdahale akışının "
              "çalışabilmesi için Sirius'un bildirimlere "
              "erişim iznine sahip olması gerekir.",
          style: TextStyle(
            fontSize: 16,
            height: 1.55,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
