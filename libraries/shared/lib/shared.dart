import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared/common/location_services.dart';
import 'package:shared/common/utils/color_palettes.dart';
import 'package:shared/common/utils/named_routes.dart';

class SharedModule extends Module {
  // void exportBinds(i) {
  //   i.add<NamedRoutes>(() => NamedRoutes(), export: true);
  // }

  @override
  List<Bind> get binds => [
    Bind((_) => NamedRoutes(), export: true),
    Bind((_) => ColorPalettes(), export: true),
    Bind((_) => LocationService(), export: true),
  ];

  List<ModularRoute> get routes => [];
}
