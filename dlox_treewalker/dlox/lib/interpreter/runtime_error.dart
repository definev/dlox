import 'package:dlox/token.dart';

class RuntimeError implements Exception {
  final Token token;
  final String message;

  const RuntimeError(this.token, this.message);

  @override
  String toString() => '$token: $message';
}
