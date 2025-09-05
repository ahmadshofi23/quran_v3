import 'package:asmaulhusna/data/remote/remote_asmaulhusna_data_sources.dart';
import 'package:asmaulhusna/data/repositories/asmaulhusna_repository.dart';
import 'package:asmaulhusna/domain/repositories_impl/asmaulhusna_repositories_impl.dart';
import 'package:asmaulhusna/domain/usecase/asmaulhusna_usecase.dart';
import 'package:asmaulhusna/presentation/bloc/bloc/asmaul_husna_bloc.dart';
import 'package:doa/data/remote/remote_doa_data_sources.dart';
import 'package:doa/data/repositories/doa_repository.dart';
import 'package:doa/domain/repositories_impl/doa_repository_impl.dart';
import 'package:doa/domain/usecase/doa_usecase.dart';
import 'package:doa/presentation/bloc/bloc/doa_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
import 'package:surah/data/remote/remote_quran.dart';
import 'package:surah/data/repositories/quran_repository_impl.dart';
import 'package:surah/domain/repositories/quran_repository.dart';
import 'package:surah/domain/usecase/quran_usecase.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surah/presentation/bloc/bloc/quran_bloc.dart';

// Make sure the import path above is correct and points to the file where LocationService is defined.
class FeatureHomeModule extends Module {
  FeatureHomeModule();

  final _namedRoutes = Modular.get<NamedRoutes>();

  @override
  List<Bind> get binds => [
    Bind((_) => HomeRemoteDataSourcesImpl()),
    Bind(
      (_) => RemoteQuranDataSourceImpl(
        // dio: Modular.get<Dio>(),
      ),
    ),
    Bind((_) => RemoteDoaDataSourcesImpl()),

    Bind((_) => RemoteAsmaulHusnaDataSourcesImpl()),

    Bind(
      (_) => HomeRepositoriesImpl(
        remoteDataSources: Modular.get<HomeRemoteDataSources>(),
      ),
    ),
    Bind(
      (_) => QuranRepositoryImpl(
        remoteQuranDataSource: Modular.get<RemoteQuranDataSource>(),
      ),
    ),
    Bind(
      (_) => DoaRepositoryImpl(
        remoteDoaDataSources: Modular.get<RemoteDoaDataSources>(),
      ),
    ),
    Bind(
      (_) => AsmaulhusnaRepositoriesImpl(
        remoteAsmaulHusnaDataSources:
            Modular.get<RemoteAsmaulHusnaDataSources>(),
      ),
    ),

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
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(Modular.initialRoute, child: (context, args) => SplashPages()),

    ChildRoute(
      _namedRoutes.home,
      child:
          (context, args) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create:
                    (context) =>
                        QuranBloc(useCase: Modular.get<QuranUseCase>()),
              ),
              BlocProvider(
                create: (_) => LocationBloc()..add(StartLocationTracking()),
              ),
              BlocProvider(
                create:
                    (context) =>
                        HomeBloc(homeUsecase: Modular.get<HomeUsecase>()),
              ),
              BlocProvider(
                create:
                    (context) => DoaBloc(usecase: Modular.get<DoaUsecase>()),
              ),
              BlocProvider(
                create:
                    (context) => AsmaulHusnaBloc(
                      usecase: Modular.get<AsmaulHusnaUsecase>(),
                    ),
              ),
            ],
            child: HomePages(),
          ),
    ),
  ];
}
