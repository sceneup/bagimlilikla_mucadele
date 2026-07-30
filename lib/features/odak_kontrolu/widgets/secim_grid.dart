import 'package:bagimlilik/features/odak_kontrolu/models/secilebilir_oge.dart';
import 'package:bagimlilik/features/odak_kontrolu/widgets/secim_karti.dart';
import 'package:flutter/material.dart';

class SecimGrid<T extends SecilebilirOge> extends StatelessWidget {
  final List<T> ogeler;
  final ValueChanged<T> onSecildi;

  const SecimGrid({
    required this.ogeler,
    required this.onSecildi,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ogeler.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final oge = ogeler[index];
        return SecimKarti(
          isim: oge.isim,
          ikon: oge.ikon,
          arkaplanRengi: oge.arkaplanRengi,
          simgeRengi: oge.simgeRengi,
          onTap: () => onSecildi(oge),
        );
      },
    );
  }
}
