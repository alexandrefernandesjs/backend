import 'dart:io';

class DotEnvService {
  final Map<String, String> _map = {};
  static DotEnvService instance = DotEnvService._();
  DotEnvService._();

  void _init() {
    final file = File('.env');
    final envText = file.readAssStringSync();

    for (var line in envText.split('\n')) {
      final lineBreak = line.split('=');
    }
  }
}
