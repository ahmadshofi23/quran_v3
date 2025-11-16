import 'package:core/database_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hadist/data/remote/local_hadist_data_source.dart';
import 'package:hadist/data/remote/remote_hadist_data_sources.dart';
import 'package:hadist/data/repositories/hadist_repository.dart';
import 'package:hadist/domain/repositories_impl/hadist_repository_impl.dart';
import 'package:hadist/domain/usecase/hadist_usecase.dart';
import 'package:hadist/presentation/bloc/bloc/hadist_bloc.dart';
import 'package:hadist/presentation/ui/detail_hadist_page.dart';
import 'package:hadist/presentation/ui/hadist_page.dart';
import 'package:shared/common/utils/named_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureHadistModule extends Module {
  FeatureHadistModule();

  final _namedRoutes = Modular.get<NamedRoutes>();

  @override
  List<Bind> get binds => [
    Bind(
      (_) => RemoteHadistDataSourcesImpl(),
      // dio: Modular.get<Dio>(),
    ),
    Bind(
      (_) => LocalHadistDataSourceImpl(
        databaseHelper: Modular.get<DatabaseHelper>(),
      ),
    ),
    Bind(
      (_) => HadistRepositoryImpl(
        remoteHadistDataSources: Modular.get<RemoteHadistDataSources>(),
        localHadistDataSource: Modular.get<LocalHadistDataSource>(),
      ),
    ),

    Bind(
      (_) =>
          HadistUsecaseImpl(hadistRepository: Modular.get<HadistRepository>()),
    ),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      _namedRoutes.asmaulHusna,
      child:
          (context, args) => BlocProvider(
            create:
                (context) =>
                    HadistBloc(Modular.get<HadistUsecase>())
                      ..add(FetchHadistEvent()),
            child: const HadistPage(),
          ),
    ),

    ChildRoute(
      _namedRoutes.detailHadist,
      child: (context, args) => DetailHadistPage(hadist: args.data),
    ),
  ];
}
