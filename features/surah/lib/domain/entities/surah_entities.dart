class SurahEntity {
  final int? nomor;
  final String? nama;
  final String? namaLatin;
  final int? jumlahAyat;
  final String? tempatTurun;
  final String? arti;
  final String? deskripsi;
  final String? audio;

  SurahEntity({
    this.nomor,
    this.nama,
    this.namaLatin,
    this.jumlahAyat,
    this.tempatTurun,
    this.arti,
    this.deskripsi,
    this.audio,
  });

  SurahEntity copyWith({
    int? nomor,
    String? nama,
    String? namaLatin,
    int? jumlahAyat,
    String? tempatTurun,
    String? arti,
    String? deskripsi,
    String? audio,
  }) => SurahEntity(
    nomor: nomor ?? this.nomor,
    nama: nama ?? this.nama,
    namaLatin: namaLatin ?? this.namaLatin,
    jumlahAyat: jumlahAyat ?? this.jumlahAyat,
    tempatTurun: tempatTurun ?? this.tempatTurun,
    arti: arti ?? this.arti,
    deskripsi: deskripsi ?? this.deskripsi,
    audio: audio ?? this.audio,
  );

  Map<String, dynamic> toMap() {
    return {
      'nomor': nomor,
      'nama': nama,
      'nama_latin': namaLatin,
      'jumlah_ayat': jumlahAyat,
      'tempat_turun': tempatTurun,
      'arti': arti,
      'deskripsi': deskripsi,
      'audio': audio,
    };
  }

  factory SurahEntity.fromMap(Map<String, dynamic> map) {
    return SurahEntity(
      nomor: map['nomor'] as int?,
      nama: map['nama'] as String?,
      namaLatin: map['nama_latin'] as String?,
      jumlahAyat: map['jumlah_ayat'] as int?,
      tempatTurun: map['tempat_turun'] as String?,
      arti: map['arti'] as String?,
      deskripsi: map['deskripsi'] as String?,
      audio: map['audio'] as String?,
    );
  }
}
