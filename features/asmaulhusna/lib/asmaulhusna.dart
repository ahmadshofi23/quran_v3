import 'package:asmaulhusna/data/remote/remote_asmaulhusna_data_sources.dart';
import 'package:asmaulhusna/data/repositories/asmaulhusna_repository.dart';
import 'package:asmaulhusna/domain/repositories_impl/asmaulhusna_repositories_impl.dart';
import 'package:asmaulhusna/domain/usecase/asmaulhusna_usecase.dart';
import 'package:asmaulhusna/presentation/bloc/bloc/asmaul_husna_bloc.dart';
import 'package:asmaulhusna/presentation/ui/asmaulhusna_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared/common/utils/named_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureAsmaulHusnaModule extends Module {
  FeatureAsmaulHusnaModule();

  final _namedRoutes = Modular.get<NamedRoutes>();

  @override
  List<Bind> get binds => [
    Bind(
      (_) => RemoteAsmaulHusnaDataSourcesImpl(),
      // dio: Modular.get<Dio>(),
    ),
    Bind(
      (_) => AsmaulhusnaRepositoriesImpl(
        remoteAsmaulHusnaDataSources:
            Modular.get<RemoteAsmaulHusnaDataSources>(),
      ),
    ),

    Bind(
      (_) => AsmaulHusnaUsecaseImpl(
        asmaulhusnaRepository: Modular.get<AsmaulhusnaRepository>(),
      ),
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
                    AsmaulHusnaBloc(usecase: Modular.get<AsmaulHusnaUsecase>())
                      ..add(FetchAsmaulHusnaEvent()),
            child: const AsmaulhusnaPage(),
          ),
    ),
  ];
}
