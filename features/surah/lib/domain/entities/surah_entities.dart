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
}
