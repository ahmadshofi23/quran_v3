import 'package:asmaulhusna/data/remote/local_asmaulhusana_data_source.dart';
import 'package:asmaulhusna/data/remote/remote_asmaulhusna_data_sources.dart';
import 'package:asmaulhusna/data/repositories/asmaulhusna_repository.dart';
import 'package:asmaulhusna/domain/repositories_impl/asmaulhusna_repositories_impl.dart';
import 'package:asmaulhusna/domain/usecase/asmaulhusna_usecase.dart';
import 'package:asmaulhusna/presentation/bloc/bloc/asmaul_husna_bloc.dart';
import 'package:core/database_helper.dart';
import 'package:doa/data/remote/local_doa_data_sources.dart';
import 'package:doa/data/remote/remote_doa_data_sources.dart';
import 'package:doa/data/repositories/doa_repository.dart';
import 'package:doa/domain/repositories_impl/doa_repository_impl.dart';
import 'package:doa/domain/usecase/doa_usecase.dart';
import 'package:doa/presentation/bloc/bloc/doa_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hadist/data/remote/local_hadist_data_source.dart';
import 'package:hadist/data/remote/remote_hadist_data_sources.dart';
import 'package:hadist/data/repositories/hadist_repository.dart';
import 'package:hadist/domain/repositories_impl/hadist_repository_impl.dart';
import 'package:hadist/domain/usecase/hadist_usecase.dart';
import 'package:hadist/presentation/bloc/bloc/hadist_bloc.dart';
import 'package:home/data/remote/home_remote_data_sources.dart';
import 'package:home/data/repositories/home_repositories_impl.dart';
import 'package:home/domain/repository/home_repository.dart';
import 'package:home/domain/usecase/home_usecase.dart';
import 'package:home/presentation/bloc/home/home_bloc.dart';
import 'package:home/presentation/bloc/location/location_bloc.dart';
import 'package:home/presentation/bloc/location/location_event.dart';
import 'package:home/presentation/ui/home_pages.dart';
import 'package:home/presentation/ui/splash_pages.dart';
import 'package:shared/common/utils/named_routes.dart';
import 'package:surah/data/remote/local_quran_data_sources.dart';
import 'package:surah/data/remote/remote_quran.dart';
import 'package:surah/data/repositories/quran_repository_impl.dart';
import 'package:surah/domain/repositories/quran_repository.dart';
import 'package:surah/domain/usecase/quran_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surah/presentation/bloc/bloc/quran_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FeatureHomeModule extends Module {
  FeatureHomeModule();

  final _namedRoutes = Modular.get<NamedRoutes>();

  @override
  List<Bind> get binds => [
    // 🔔 Notifikasi Plugin (singleton)
    Bind.singleton((_) => FlutterLocalNotificationsPlugin()),
    Bind(
      (_) => LocalQuranDataSourcesImpl(
        databaseHelper: Modular.get<DatabaseHelper>(),
      ),
    ),
    Bind(
      (_) =>
          LocalDoaDataSourceImpl(databaseHelper: Modular.get<DatabaseHelper>()),
    ),
    Bind(
      (_) => LocalAsmaulhusanaDataSourceImpl(
        databaseHelper: Modular.get<DatabaseHelper>(),
      ),
    ),
    Bind(
      (_) => LocalHadistDataSourceImpl(
        databaseHelper: Modular.get<DatabaseHelper>(),
      ),
    ),

    // Data sources
    Bind((_) => HomeRemoteDataSourcesImpl()),
    Bind((_) => RemoteQuranDataSourceImpl()),
    Bind((_) => RemoteDoaDataSourcesImpl()),
    Bind((_) => RemoteAsmaulHusnaDataSourcesImpl()),
    Bind((_) => RemoteHadistDataSourcesImpl()),

    // Repository
    Bind(
      (_) => HomeRepositoriesImpl(
        remoteDataSources: Modular.get<HomeRemoteDataSources>(),
      ),
    ),
    Bind(
      (_) => QuranRepositoryImpl(
        remoteQuranDataSource: Modular.get<RemoteQuranDataSource>(),
        localQuranDataSources: Modular.get<LocalQuranDataSources>(),
      ),
    ),
    Bind(
      (_) => DoaRepositoryImpl(
        remoteDoaDataSources: Modular.get<RemoteDoaDataSources>(),
        localDoaDataSources: Modular.get<LocalDoaDataSources>(),
      ),
    ),
    Bind(
      (_) => AsmaulhusnaRepositoriesImpl(
        remoteAsmaulHusnaDataSources:
            Modular.get<RemoteAsmaulHusnaDataSources>(),
        localAsmaulHusnaDataSource: Modular.get<LocalAsmaulHusnaDataSource>(),
      ),
    ),
    Bind(
      (_) => HadistRepositoryImpl(
        remoteHadistDataSources: Modular.get<RemoteHadistDataSources>(),
        localHadistDataSource: Modular.get<LocalHadistDataSource>(),
      ),
    ),

    // Usecases
    Bind((_) => HomeUsecaseImpl(repository: Modular.get<HomeRepository>())),
    Bind(
      (_) => QuranUseCaseImpl(quranRepository: Modular.get<QuranRepository>()),
    ),
    Bind((_) => DoaUsecaseImpl(doaRepository: Modular.get<DoaRepository>())),
    Bind(
      (_) => AsmaulHusnaUsecaseImpl(
        asmaulhusnaRepository: Modular.get<AsmaulhusnaRepository>(),
      ),
    ),

    Bind(
      (_) =>
          HadistUsecaseImpl(hadistRepository: Modular.get<HadistRepository>()),
    ),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(Modular.initialRoute, child: (_, __) => SplashPages()),
    ChildRoute(
      _namedRoutes.home,
      child:
          (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => QuranBloc(useCase: Modular.get<QuranUseCase>()),
              ),
              BlocProvider(
                create: (_) => LocationBloc()..add(StartLocationTracking()),
              ),
              BlocProvider(
                create:
                    (_) => HomeBloc(
                      homeUsecase: Modular.get<HomeUsecase>(),
                      notificationsPlugin:
                          Modular.get<FlutterLocalNotificationsPlugin>(),
                    ),
              ),
              BlocProvider(
                create: (_) => DoaBloc(usecase: Modular.get<DoaUsecase>()),
              ),
              BlocProvider(
                create:
                    (_) => AsmaulHusnaBloc(
                      usecase: Modular.get<AsmaulHusnaUsecase>(),
                    ),
              ),
              BlocProvider(
                create: (_) => HadistBloc(Modular.get<HadistUsecase>()),
              ),
            ],
            child: HomePages(),
          ),
    ),
  ];
}
