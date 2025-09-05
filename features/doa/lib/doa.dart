import 'package:doa/data/remote/remote_doa_data_sources.dart';
import 'package:doa/data/repositories/doa_repository.dart';
import 'package:doa/domain/repositories_impl/doa_repository_impl.dart';
import 'package:doa/domain/usecase/doa_usecase.dart';
import 'package:doa/presentation/bloc/bloc/doa_bloc.dart';
import 'package:doa/presentation/ui/detail_doa_page.dart';
import 'package:doa/presentation/ui/doa_pages.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared/common/utils/named_routes.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureDoaModule extends Module {
  FeatureDoaModule();

  final _namedRoutes = Modular.get<NamedRoutes>();

  @override
  List<Bind> get binds => [
    Bind(
      (_) => RemoteDoaDataSourcesImpl(),
      // dio: Modular.get<Dio>(),
    ),
    Bind(
      (_) => DoaRepositoryImpl(
        remoteDoaDataSources: Modular.get<RemoteDoaDataSources>(),
      ),
    ),

    Bind((_) => DoaUsecaseImpl(doaRepository: Modular.get<DoaRepository>())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      _namedRoutes.doa,
      child:
          (context, args) => BlocProvider(
            create: (context) => DoaBloc(usecase: Modular.get<DoaUsecase>()),
            child: const DoaPage(),
          ),
    ),

    ChildRoute(
      _namedRoutes.detailDoa,
      child: (context, args) => DetailDoaPage(doa: args.data),
    ),
  ];
}
