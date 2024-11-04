extension ListDoubleEx on Iterable<double> {
  bool get isAscending {
    for (int i = 0; i < length - 1; i++) {
      if (elementAt(i) > elementAt(i + 1)) {
        return false;
      }
    }
    return true;
  }
}
