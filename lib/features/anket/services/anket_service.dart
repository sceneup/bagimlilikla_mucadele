import 'dart:convert';
import 'package:bagimlilik/features/anket/models/anket_bolumu.dart';
import 'package:flutter/services.dart';

class AnketService {

  Future<List<AnketBolum>> anketiYukle() async {
    final jsonString =
    await rootBundle.loadString("assets/jsons/anket.json");

    final jsonMap = jsonDecode(jsonString);

    final bolumler = jsonMap["bolumler"] as List;

    return bolumler
        .map((e) => AnketBolum.fromJson(e))
        .toList();
  }

}

