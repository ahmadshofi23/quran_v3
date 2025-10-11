import 'package:asmaulhusna/asmaulhusna.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_modular/flutter_modular.dart';
import 'package:home/home.dart';
import 'package:shared/common/location_services.dart';
import 'package:shared/common/utils/named_routes.dart';
import 'package:shared/shared.dart';
import 'package:surah/surah.dart';
import 'package:doa/doa.dart';
import 'package:hadist/hadist.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [SharedModule()];

  // void exportBinds(i) {
  //   i.addSingleton<NamedRoutes>(() => NamedRoutes(), export: true);
  // }
  @override
  List<Bind> get binds => [
    Bind.singleton((_) => LocationService(), export: true),
    Bind((_) => NamedRoutes(), export: true),

    // Bind((_) => RemoteQuranDataSourceImpl(
    //   // dio: Modular.get<Dio>()
    //   ),
    // ),
    // Bind(
    //       (_) => QuranRepositoryImpl(
    //     remoteQuranDataSource: Modular.get<RemoteQuranDataSource>(),
    //   ),
    // ),
    // Bind((_) => QuranUseCaseImpl(
    //     quranRepository: Modular.get<QuranRepository>()),
    // ),
  ];

  // @override
  // void routes(r) {
  //   r.module(Modular.initialRoute, module: FeatureSurahModule());

  //   r.module(Modular.get<NamedRoutes>().home, module: FeatureSurahModule());
  // }

  @override
  List<ModularRoute> get routes => [
    ModuleRoute(Modular.initialRoute, module: FeatureHomeModule()),
    ModuleRoute(Modular.get<NamedRoutes>().home, module: FeatureHomeModule()),
    ModuleRoute(Modular.get<NamedRoutes>().surah, module: FeatureSurahModule()),
    ModuleRoute(Modular.get<NamedRoutes>().doa, module: FeatureDoaModule()),
    ModuleRoute(
      Modular.get<NamedRoutes>().asmaulHusna,
      module: FeatureAsmaulHusnaModule(),
    ),
    ModuleRoute(
      Modular.get<NamedRoutes>().hadist,
      module: FeatureHadistModule(),
    ),
  ];
}

class QuranApp extends StatefulWidget {
  const QuranApp({super.key});

  @override
  State<QuranApp> createState() => _QuranAppState();
}

class _QuranAppState extends State<QuranApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
