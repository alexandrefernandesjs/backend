import 'dart:convert';
import 'dart:async';

import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class ClientResource extends Resource {
  @override
  // TODO: implement routes
  List<Route> get routes => [
        Route.get('/clients', _getAllClients),
        Route.get('/client/:id', _getProductByid),
        Route.post('/client', _createProduct),
        Route.put('/client', _updateProduct),
        Route.delete('/client/:id', _deteleProduct),
      ];

  FutureOr<Response> _getAllClients(Injector injector) async {
    final database = injector.get<RemoteDatabase>();

    final result = await database
        .query('SELECT id, nome, unidade, role, preco	FROM public."Product"');
    final productMap = result.map((element) => element['Product']).first;
    return Response.ok(jsonEncode(productMap));
  }

  FutureOr<Response> _getProductByid(
      ModularArguments arguments, Injector injector) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    final result = await database
        .query('SELECT id, nome, unidade, role, preco	FROM public."Product"');
    final productMap = result.map((element) => element['Product']).first;

    return Response.ok(jsonEncode(productMap));
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