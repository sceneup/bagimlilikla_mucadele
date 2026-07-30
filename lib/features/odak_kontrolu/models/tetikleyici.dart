import 'package:bagimlilik/features/odak_kontrolu/models/secilebilir_oge.dart';
import 'package:flutter/material.dart';

class Tetikleyici implements SecilebilirOge {
  @override
  final String id;
  @override
  final String isim;
  @override
  final IconData ikon;
  @override
  final Color arkaplanRengi;
  @override
  final Color simgeRengi;

  const Tetikleyici({
    required this.id,
    required this.isim,
    required this.ikon,
    required this.arkaplanRengi,
    required this.simgeRengi,
  });
}
