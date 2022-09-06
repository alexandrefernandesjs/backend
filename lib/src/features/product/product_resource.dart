import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class ProductResource extends Resource {
  @override
  // TODO: implement routes
  List<Route> get routes => [
        Route.get('/products', _getAllProducts),
        Route.get('/product/:id', _getProductByid),
        Route.post('/product', _createProduct),
        Route.put('/product', _updateProduct),
        Route.delete('/product/:id', _deteleProduct),
      ];

  FutureOr<Response> _getAllProducts() {
    return Response.ok('OK');
  }

  FutureOr<Response> _getProductByid(ModularArguments arguments) {
    return Response.ok('Product ${arguments.params['id']}');
  }

  FutureOr<Response> _createProduct(ModularArguments arguments) {
    return Response.ok('Create Product ${arguments.data}');
  }

  FutureOr<Response> _updateProduct(ModularArguments arguments) {
    return Response.ok('Updated Prodduct ${arguments.params['id']}');
  }

  FutureOr<Response> _deteleProduct(ModularArguments arguments) {
    return Response.ok('Deleted Product ${arguments.params['id']}');
  }
}