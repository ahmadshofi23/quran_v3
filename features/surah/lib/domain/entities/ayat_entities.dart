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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'surah_number': surah,
      'nomor': nomor,
      'ar': ar,
      'tr': tr,
      'idn': idn,
    };
  }

  factory AyatEntity.fromMap(Map<String, dynamic> map) {
    return AyatEntity(
      id: map['id'] as int?,
      surah: map['surah_number'] as int?,
      nomor: map['nomor'] as int?,
      ar: map['ar'] as String?,
      tr: map['tr'] as String?,
      idn: map['idn'] as String?,
    );
  }
}
