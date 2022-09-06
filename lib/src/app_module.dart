import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'features/product/product_resource.dart';

class AppModule extends Module {
  @override
  //
  List<ModularRoute> get routes => [
        Route.get('/', (Request request) => Response.ok('Hello')),
        Route.resource(ProductResource())
      ];
}
