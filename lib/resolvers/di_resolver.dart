import 'package:meta/meta.dart';

/// Resolver is an abstraction
/// that defines how container will resolve dependency
abstract class Resolver<T> {
  T resolve();
  @protected void onRegister() {}
  @protected void dispose() {}
}