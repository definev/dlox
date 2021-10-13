import 'package:dlox/native.dart';
import 'package:test/fake.dart';

class NativeCallScope extends Fake implements NativeCall {
  String output = "";

  @override
  String print(dynamic object) {
    output += object.toString() + "\n";
    return object.toString();
  }
}
