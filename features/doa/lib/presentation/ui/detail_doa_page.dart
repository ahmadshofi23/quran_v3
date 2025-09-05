import 'package:doa/domain/entity/doa_entity.dart';
import 'package:flutter/material.dart';

class DetailDoaPage extends StatelessWidget {
  final DoaEntity doa;
  DetailDoaPage({super.key, required this.doa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doa.judul ?? 'Detail Doa'),
        centerTitle: false,
        backgroundColor: const Color(0xff9543FF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xff9543FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                doa.arab ?? '',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              doa.indo ?? '',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
