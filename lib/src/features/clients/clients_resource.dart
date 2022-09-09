import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class ClientResource extends Resource {
  @override
  // TODO: implement routes
  List<Route> get routes => [
        Route.get('/clients', _getAllClients),
        Route.get('/client/:id', _getClientByid),
        Route.post('/client', _createClient),
        Route.put('/client', _updateClient),
        Route.delete('/client/:id', _deteleClient),
      ];

  FutureOr<Response> _getAllClients(Injector injector) async {
    final database = injector.get<RemoteDatabase>();

    final result = await database
        .query('SELECT id, nome, role, cc, cpf, limite FROM "Client";');
    // final productMap = result.map((element) => element['Product']).first;
    return Response.ok(jsonEncode(result));
  }

  FutureOr<Response> _getClientByid(
      ModularArguments arguments, Injector injector) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
        'SELECT id, nome, role, cc, cpf, limite FROM "Client" WHERE id = @id;',
        variables: {'id': id});
    final clientMap = result.map((element) => element['Client']).first;
    return Response.ok(jsonEncode(clientMap));
  }

  FutureOr<Response> _createClient(
      ModularArguments arguments, Injector injector) async {
    final clientParams = (arguments.data as Map).cast<String, dynamic>();
    clientParams.remove('id');

    final database = injector.get<RemoteDatabase>();
    final insertClient = await database.query(
        'INSERT INTO "Client"(nome, cc, cpf, limite)VALUES (@nome, @cc, @cpf, @limite) RETURNING id, nome, cc, cpf, limite, role;',
        variables: clientParams);
    final clientMap = insertClient.map((element) => element['Client']).first;

    return Response.ok(jsonEncode(clientMap));
  }

  FutureOr<Response> _updateClient(
      ModularArguments arguments, Injector injector) async {
    final clientPArams = (arguments.data as Map).cast<String, dynamic>();

    final columns = clientPArams.keys
        .where((key) => key != 'id' || key != 'role')
        .map((key) => '$key=@$key')
        .toList();
    final database = injector.get<RemoteDatabase>();
    final updateClient = await database.query(
        'UPDATE "Client"SET ${columns.join(',')} WHERE id = @id RETURNING id, nome, cc, cpf, limite, role;',
        variables: clientPArams);
    final clientMap = updateClient.map((element) => element['Client']).first;

    return Response.ok(jsonEncode(clientMap));
  }

  FutureOr<Response> _deteleClient(
      ModularArguments arguments, Injector injector) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    final result = await database
        .query('DELETE FROM "Client" WHERE id = @id;', variables: {'id': id});
    return Response.ok(jsonEncode({'message': 'deleted $id'}));
  }
}
