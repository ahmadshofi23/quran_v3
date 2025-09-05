String cleanCityName(String input) {
  final pattern = RegExp(r'\b(Kabupaten|Kota|KAB.)\b\s*', caseSensitive: false);
  return input.replaceAll(pattern, '').trim();
}
