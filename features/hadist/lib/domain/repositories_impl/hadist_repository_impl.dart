import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hadist/data/remote/local_hadist_data_source.dart';
import 'package:hadist/data/remote/remote_hadist_data_sources.dart';
import 'package:hadist/data/repositories/hadist_repository.dart';
import 'package:hadist/domain/entity/hadist_entity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:retry/retry.dart';

class HadistRepositoryImpl implements HadistRepository {
  final RemoteHadistDataSources remoteHadistDataSources;
  final LocalHadistDataSource localHadistDataSource;
  HadistRepositoryImpl({
    required this.remoteHadistDataSources,
    required this.localHadistDataSource,
  });

  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<List<HadistEntity>> getAllHadist() async {
    List<HadistEntity> dataHadist = [];

    if (await _isOnline()) {
      try {
        final response = await retry(
          () => remoteHadistDataSources.getAllHadist().timeout(
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
        dataHadist =
            response.data!
                .map(
                  (e) => HadistEntity(
                    arab: e.arab,
                    indo: e.indo,
                    judul: e.judul,
                    no: e.no,
                  ),
                )
                .toList();

        await localHadistDataSource.insertAllHadist(dataHadist);
        return dataHadist;
      } catch (e, s) {
        debugPrint('⚠️ Error fetch Hadist: $e\n$s');
        return await localHadistDataSource.getAllHadist();
      }
    } else {
      return await localHadistDataSource.getAllHadist();
    }
  }
}
