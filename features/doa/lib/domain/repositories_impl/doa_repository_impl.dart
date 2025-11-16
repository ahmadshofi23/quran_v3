import 'dart:async';
import 'dart:io';

import 'package:doa/data/remote/local_doa_data_sources.dart';
import 'package:doa/data/remote/remote_doa_data_sources.dart';
import 'package:doa/domain/entity/doa_entity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:retry/retry.dart';

import '../../data/repositories/doa_repository.dart';

class DoaRepositoryImpl extends DoaRepository {
  final RemoteDoaDataSources remoteDoaDataSources;
  final LocalDoaDataSources localDoaDataSources;
  DoaRepositoryImpl({
    required this.remoteDoaDataSources,
    required this.localDoaDataSources,
  });

  Future<bool> _isOnline() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity != ConnectivityResult.none;
  }

  @override
  Future<List<DoaEntity>> getAllDoa() async {
    if (await _isOnline()) {
      try {
        final response = await retry(
          () => remoteDoaDataSources.getAllDoa().timeout(
            const Duration(seconds: 15),
          ),
          // ignore: unnecessary_type_check
          retryIf:
              (e) =>
                  // ignore: unnecessary_type_check
                  e is Exception ||
                  e is TimeoutException ||
                  e is SocketException,
          maxAttempts: 3,
        );
        final remoteData = response.data ?? [];
        final doaEntities =
            remoteData
                .map(
                  (e) => DoaEntity(arab: e.arab, indo: e.indo, judul: e.judul),
                )
                .toList();
        await localDoaDataSources.insertAllDoa(doaEntities);
        return doaEntities;
      } catch (e, s) {
        debugPrint('⚠️ Error fetch doa: $e\n$s');
        return await localDoaDataSources.getAllDoa();
      }
    } else {
      return await localDoaDataSources.getAllDoa();
    }
  }
}
