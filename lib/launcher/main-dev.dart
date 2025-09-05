import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:quran_v3/app/quran_app.dart';

void main() async {
  runApp(ModularApp(module: AppModule(), child: const QuranApp()));
}
