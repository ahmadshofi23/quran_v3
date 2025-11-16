import 'dart:async';
import 'dart:io';

import 'package:asmaulhusna/data/remote/local_asmaulhusana_data_source.dart';
import 'package:asmaulhusna/data/remote/remote_asmaulhusna_data_sources.dart';
import 'package:flutter/foundation.dart';

import '../../data/repositories/asmaulhusna_repository.dart';
import '../entity/asmaulhusna_entity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:retry/retry.dart';

class AsmaulhusnaRepositoriesImpl extends AsmaulhusnaRepository {
  final RemoteAsmaulHusnaDataSources remoteAsmaulHusnaDataSources;
  final LocalAsmaulHusnaDataSource localAsmaulHusnaDataSource;

  AsmaulhusnaRepositoriesImpl({
    required this.remoteAsmaulHusnaDataSources,
    required this.localAsmaulHusnaDataSource,
  });

  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<List<AsmaulhusnaEntity>> getAsmaulHusna() async {
    List<AsmaulhusnaEntity> dataAsmaulHusna = [];

    if (await _isOnline()) {
      try {
        final response = await retry(
          () => remoteAsmaulHusnaDataSources.getAsmaulHusna().timeout(
            Duration(seconds: 15),
          ),
          retryIf:
              (e) =>
                  // ignore: unnecessary_type_check
                  e is Exception ||
                  e is TimeoutException ||
                  e is SocketException,
          maxAttempts: 3,
        );
        dataAsmaulHusna =
            response.data!
                .map(
                  (e) => AsmaulhusnaEntity(
                    arab: e.arab,
                    id: e.id,
                    indo: e.indo,
                    latin: e.latin,
                  ),
                )
                .toList();
        await localAsmaulHusnaDataSource.insertAsmaulHusna(dataAsmaulHusna);
        return dataAsmaulHusna;
      } catch (e, s) {
        debugPrint('⚠️ Error fetch asmaul husna: $e\n$s');
        return await localAsmaulHusnaDataSource.getAllAsmaulHusna();
      }
    } else {
      return await localAsmaulHusnaDataSource.getAllAsmaulHusna();
    }
  }
}
