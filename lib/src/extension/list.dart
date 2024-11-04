extension NullableList<T> on List<T> {
  T? safeElementAtOrNull(int index) {
    if (0 <= index && index < length) {
      return this[index];
    }
    return null;
  }
}
