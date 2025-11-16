import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';
import 'package:surah/data/models/surah_model.dart';
import 'package:surah/domain/entities/ayat_entities.dart';
import 'package:surah/domain/entities/surah_entities.dart';
import 'package:surah/domain/repositories/quran_repository.dart';
import '../remote/remote_quran.dart';
import '../remote/local_quran_data_sources.dart';

class QuranRepositoryImpl extends QuranRepository {
  final RemoteQuranDataSource remoteQuranDataSource;
  final LocalQuranDataSources localQuranDataSources;

  QuranRepositoryImpl({
    required this.remoteQuranDataSource,
    required this.localQuranDataSources,
  });

  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// 🕌 Get all Surah (online -> cache -> offline)
  @override
  Future<List<SurahEntity>> getAllSurah() async {
    if (await _isOnline()) {
      try {
        // Retry 3x kalau koneksi putus sesaat
        final response = await retry(
          () => remoteQuranDataSource.getAllSurah().timeout(
            const Duration(seconds: 15),
          ),
          retryIf:
              (e) =>
                  // ignore: unnecessary_type_check
                  e is Exception ||
                  e is TimeoutException ||
                  e is SocketException,
          maxAttempts: 3,
        );

        // Parsing besar dijalankan di isolate agar tidak membekukan UI
        final dataSurah = await compute(_mapSurahList, response);

        await localQuranDataSources.insertAllSurah(dataSurah);
        return dataSurah;
      } catch (e, s) {
        debugPrint('⚠️ Error fetch surah: $e\n$s');
        return await localQuranDataSources.getAllSurah();
      }
    } else {
      return await localQuranDataSources.getAllSurah();
    }
  }

  static List<SurahEntity> _mapSurahList(List<dynamic> response) {
    return response.map((item) {
      // Ambil enum TempatTurun dan ubah ke string lowercase
      String tempatTurunString;
      if (item.tempatTurun == TempatTurun.MADINAH) {
        tempatTurunString = "madinah";
      } else if (item.tempatTurun == TempatTurun.MEKAH) {
        tempatTurunString = "mekah";
      } else {
        tempatTurunString = "tidak diketahui";
      }

      return SurahEntity(
        nomor: item.nomor,
        nama: item.nama,
        namaLatin: item.namaLatin,
        jumlahAyat: item.jumlahAyat,
        tempatTurun: tempatTurunString,
        arti: item.arti,
        deskripsi: item.deskripsi,
        audio: item.audio,
      );
    }).toList();
  }

  /// 📖 Get detail surah (online -> cache -> offline)
  @override
  Future<List<AyatEntity>> getDetailSurah(int numberOfSurah) async {
    if (await _isOnline()) {
      try {
        final response = await retry(
          () => remoteQuranDataSource
              .getDetailSurah(numberOfSurah)
              .timeout(const Duration(seconds: 15)),
          retryIf:
              (e) =>
                  // ignore: unnecessary_type_check
                  e is Exception ||
                  e is TimeoutException ||
                  e is SocketException,
          maxAttempts: 3,
        );

        final dataAyat =
            response.ayat.map((item) {
              return AyatEntity(
                id: item.id,
                nomor: item.nomor,
                surah: item.surah,
                ar: item.ar,
                idn: item.idn,
                tr: item.tr,
              );
            }).toList();

        await localQuranDataSources.insertAllAyat(dataAyat);
        return dataAyat;
      } catch (e, s) {
        debugPrint('⚠️ Error fetch ayat: $e\n$s');
        return await localQuranDataSources.getAyatBySurah(numberOfSurah);
      }
    } else {
      return await localQuranDataSources.getAyatBySurah(numberOfSurah);
    }
  }
}
