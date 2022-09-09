import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/database/remote_database.dart';
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

  FutureOr<Response> _getAllProducts(Injector injector) async {
    final database = injector.get<RemoteDatabase>();

    final result = await database
        .query('SELECT id, nome, unidade, preco, role	FROM "Product";');
    // final productMap = result.map((element) => element['Product']).first;
    return Response.ok(jsonEncode(result));
  }

  FutureOr<Response> _getProductByid(
      ModularArguments arguments, Injector injector) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT id, nome, preco, unidade FROM "Product" WHERE id = @id;',
        variables: {'id': id});
    final productMap = result.map((element) => element['Product']).first;
    return Response.ok(jsonEncode(productMap));
  }

  FutureOr<Response> _createProduct(
      ModularArguments arguments, Injector injector) async {
    final productParams = (arguments.data as Map).cast<String, dynamic>();
    productParams.remove('id');

    final database = injector.get<RemoteDatabase>();
    final insertProduct = await database.query(
        'INSERT INTO public."Product"(nome, unidade, preco)VALUES (@nome, @unidade, @preco) RETURNING id, nome, unidade, role, preco;',
        variables: productParams);
    final productMap = insertProduct.map((element) => element['Product']).first;

    return Response.ok(jsonEncode(productMap));
  }

  FutureOr<Response> _updateProduct(
      ModularArguments arguments, Injector injector) async {
    final productPArams = (arguments.data as Map).cast<String, dynamic>();

    final columns = productPArams.keys
        .where((key) => key != 'id' || key != 'role')
        .map((key) => '$key=@$key')
        .toList();
    final database = injector.get<RemoteDatabase>();
    final updateProduct = await database.query(
        'UPDATE "Product"	SET ${columns.join(',')} WHERE id = @id RETURNING id, nome, unidade, role, preco;',
        variables: productPArams);
    final productMap = updateProduct.map((element) => element['Product']).first;

    return Response.ok(jsonEncode(productMap));
  }

  FutureOr<Response> _deteleProduct(
      ModularArguments arguments, Injector injector) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    final result = await database
        .query('DELETE FROM "Product" WHERE id = @id;', variables: {'id': id});
    return Response.ok(jsonEncode({'message': 'deleted $id'}));
  }
}
