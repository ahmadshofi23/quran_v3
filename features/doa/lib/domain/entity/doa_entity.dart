class DoaEntity {
  final String? arab;
  final String? indo;
  final String? judul;

  DoaEntity({this.arab, this.indo, this.judul});

  Map<String, dynamic> toMap() {
    return {'arab': arab, 'indo': indo, 'judul': judul};
  }

  factory DoaEntity.fromMap(Map<String, dynamic> map) {
    return DoaEntity(
      arab: map['arab'] as String?,
      indo: map['indoe'] as String?,
      judul: map['judul'] as String?,
    );
  }
}
