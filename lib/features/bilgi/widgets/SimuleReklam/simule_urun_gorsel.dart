import 'package:flutter/material.dart';

class UrunGorselAlani extends StatelessWidget {
  const UrunGorselAlani({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.camera_enhance),
    );
  }
}