String? getWaktuSalatAktif(Map<String, String> jadwal) {
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);

  // Ubah jadwal ke format DateTime
  final salatTimes = jadwal.map((nama, jamMenit) {
    final parts = jamMenit.split(':');
    final dt = DateTime(
      today.year,
      today.month,
      today.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
    return MapEntry(nama, dt);
  });

  // Urutkan berdasarkan waktu
  final ordered =
      salatTimes.entries.toList()..sort((a, b) => a.value.compareTo(b.value));

  for (int i = 0; i < ordered.length; i++) {
    final current = ordered[i].value;
    final next = (i + 1 < ordered.length) ? ordered[i + 1].value : null;

    if (now.isBefore(current)) {
      return 'Menjelang ${ordered[i].key.toUpperCase()} (${jadwal[ordered[i].key]})';
    } else if (next != null && now.isBefore(next)) {
      return 'Waktu ${ordered[i].key.toUpperCase()} (${jadwal[ordered[i].key]})';
    }
  }

  return 'Waktu ISYAA (${jadwal["isya"]})'; // fallback malam
}
