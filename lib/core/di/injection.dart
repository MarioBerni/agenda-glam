import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // Nombre del método generado
  preferRelativeImports: true, // Preferir importaciones relativas
  asExtension: false, // No generar como extensión
)
void configureDependencies() => init(getIt);
