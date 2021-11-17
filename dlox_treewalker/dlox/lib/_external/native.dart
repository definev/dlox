import 'dart:core' as core;

// ignore: constant_identifier_names
const Native = NativeCall();

class NativeCall {
  const NativeCall();
  
  core.String print(core.dynamic object) {
    core.print(object);
    return object.toString();
  }
}
