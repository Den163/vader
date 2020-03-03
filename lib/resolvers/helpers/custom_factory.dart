
/// [CustomFactory] knows how to create a specified object [T] at runtime with
/// [make] method and it's [TArgs] argument
abstract class CustomFactory<T, TArgs> {
  T make(TArgs args);
}
