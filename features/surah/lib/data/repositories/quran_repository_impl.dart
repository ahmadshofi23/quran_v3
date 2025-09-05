import 'package:surah/domain/entities/ayat_entities.dart';
import 'package:surah/domain/entities/surah_entities.dart';
import 'package:surah/domain/repositories/quran_repository.dart';
import '../remote/remote_quran.dart';

class QuranRepositoryImpl extends QuranRepository {
  final RemoteQuranDataSource remoteQuranDataSource;

  QuranRepositoryImpl({required this.remoteQuranDataSource});

  @override
  Future<List<SurahEntity>> getAllSurah() async {
    List<SurahEntity> dataSurah = [];
    final response = await remoteQuranDataSource.getAllSurah();

    for (var item in response) {
      dataSurah.add(
        SurahEntity(
          nomor: item.nomor,
          nama: item.nama,
          namaLatin: item.namaLatin,
          jumlahAyat: item.jumlahAyat,
          tempatTurun: item.tempatTurun.name,
          arti: item.arti,
          deskripsi: item.deskripsi,
          audio: item.audio,
        ),
      );
    }

    return dataSurah;
  }

  @override
  Future<List<AyatEntity>> getDetailSurah(int numberOfSurah) async {
    List<AyatEntity> dataAyat = [];
    final response = await remoteQuranDataSource.getDetailSurah(numberOfSurah);
    for (var item in response.ayat) {
      dataAyat.add(
        AyatEntity(
          id: item.id,
          nomor: item.nomor,
          surah: item.surah,
          ar: item.ar,
          idn: item.idn,
          tr: item.tr,
        ),
      );
    }
    return dataAyat;
  }
}
