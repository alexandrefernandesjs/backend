import 'package:backend/src/core/services/database/postgres/postgres_database.dart';
import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:backend/src/features/clients/clients_resource.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'core/services/dot_env/dot_env_service.dart';
import 'features/product/product_resource.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.instance<DotEnvService>(DotEnvService.instance),
        Bind.singleton<RemoteDatabase>((i) => PostgresDatabase(i())),
      ];
  @override
  //
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('Hello')),
        Route.resource(ProductResource()),
        Route.resource(ClientResource())
      ];
}
