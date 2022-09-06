import 'dart:async';

import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:postgres/postgres.dart';

class PostgresDatabase implements RemoteDatabase {
  final completer = Completer<PostgreSQLConnection>();

  _init() async {
    var connection = PostgreSQLConnection('localhost', 5432, 'backend',
        username: 'root', password: 'root');
    await connection.open();
    completer.complete(connection);
  }

  @override
  List<Map<String, Map<String, dynamic>>> query(String queryText,
      {Map<String, String> variables = const {}});
}
