class AyatEntity {
  final int? id;
  final int? surah;
  final int? nomor;
  final String? ar;
  final String? tr;
  final String? idn;

  AyatEntity({this.id, this.surah, this.nomor, this.ar, this.tr, this.idn});

  AyatEntity copyWith({
    int? id,
    int? surah,
    int? nomor,
    String? ar,
    String? tr,
    String? idn,
  }) => AyatEntity(
    id: id ?? this.id,
    nomor: nomor ?? this.nomor,
    surah: surah ?? this.surah,
    ar: ar ?? this.ar,
    tr: tr ?? this.tr,
    idn: idn ?? this.idn,
  );
}
