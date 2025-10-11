import 'package:flutter/material.dart';
import 'package:hadist/domain/entity/hadist_entity.dart';

class DetailHadistPage extends StatelessWidget {
  final HadistEntity hadist;
  DetailHadistPage({super.key, required this.hadist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hadist.judul ?? 'Detail Doa'),
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
                hadist.arab ?? '',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hadist.indo ?? '',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
