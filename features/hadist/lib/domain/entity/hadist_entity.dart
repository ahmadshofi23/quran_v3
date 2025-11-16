class HadistEntity {
  final String? arab;
  final String? indo;
  final String? judul;
  final String? no;

  HadistEntity({this.arab, this.indo, this.judul, this.no});

  Map<String, dynamic> toMap() {
    return {'arab': arab, 'indo': indo, 'judul': judul, 'no': no};
  }

  factory HadistEntity.fromMap(Map<String, dynamic> map) {
    return HadistEntity(
      arab: map['arab'] as String?,
      indo: map['indo'] as String?,
      judul: map['judul'] as String?,
      no: map['no'] as String?,
    );
  }
}
