import 'package:core/database_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared/common/utils/named_routes.dart';
import 'package:surah/data/remote/local_quran_data_sources.dart';
import 'package:surah/data/remote/remote_quran.dart';
import 'package:surah/data/repositories/quran_repository_impl.dart';
import 'package:surah/domain/repositories/quran_repository.dart';
import 'package:surah/domain/usecase/quran_usecase.dart';
import 'package:surah/presentation/bloc/bloc/quran_bloc.dart';
import 'package:surah/presentation/bloc/detail_surah/bloc/detail_surah_bloc.dart';
import 'package:surah/presentation/ui/detail_surah_page.dart'; // Make sure this path matches the actual location of DetailSurahPage
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surah/presentation/ui/surah_page.dart';

class FeatureSurahModule extends Module {
  FeatureSurahModule();

  final _namedRoutes = Modular.get<NamedRoutes>();

  @override
  List<Bind> get binds => [
    Bind(
      (_) => RemoteQuranDataSourceImpl(
        // dio: Modular.get<Dio>(),
      ),
    ),
    Bind(
      (_) => LocalQuranDataSourcesImpl(
        databaseHelper: Modular.get<DatabaseHelper>(),
      ),
    ),
    Bind(
      (_) => QuranRepositoryImpl(
        remoteQuranDataSource: Modular.get<RemoteQuranDataSource>(),
        localQuranDataSources: Modular.get<LocalQuranDataSources>(),
      ),
    ),
    Bind(
      (_) => QuranUseCaseImpl(quranRepository: Modular.get<QuranRepository>()),
    ),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      _namedRoutes.surah,
      child:
          (context, args) => BlocProvider(
            create:
                (context) => QuranBloc(useCase: Modular.get<QuranUseCase>()),
            child: SurahPage(),
          ),
    ),

    ChildRoute(
      _namedRoutes.detailSurah,
      child:
          (context, args) => BlocProvider(
            create:
                (context) =>
                    DetailSurahBloc(quranUseCase: Modular.get<QuranUseCase>()),
            child: DetailSurahPage(
              surahEntity:
                  args.data, // You can pass the actual surah number here
            ),
          ),
    ),
  ];
}
