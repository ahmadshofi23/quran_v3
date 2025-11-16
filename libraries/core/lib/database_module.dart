import 'package:flutter_modular/flutter_modular.dart';
import 'database_helper.dart';

class DatabaseModule extends Module {
  @override
  List<Bind> get binds => [
    Bind.singleton((i) => DatabaseHelper(), export: true),
  ];
}
