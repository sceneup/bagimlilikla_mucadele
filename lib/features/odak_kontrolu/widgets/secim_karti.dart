import 'package:flutter/material.dart';

class SecimKarti extends StatelessWidget {
  final String isim;
  final IconData ikon;
  final Color arkaplanRengi;
  final Color simgeRengi;
  final VoidCallback onTap;

  const SecimKarti({
    required this.isim,
    required this.ikon,
    required this.arkaplanRengi,
    required this.simgeRengi,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: arkaplanRengi,
              ),
              child: Icon(ikon, color: simgeRengi, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              isim,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: simgeRengi,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
