class NumberFormatter {
  static String format(int value) {
    if (value < 1000) return value.toString();
    if (value >= 1000 && value < 1000000)
      return (value / 1000).toStringAsFixed(1) + 'k';
    if (value >= 1000000 && value < 1000000000)
      return (value / 1000000).toStringAsFixed(1) + 'M';
    if (value >= 1000000000 && value < 1000000000000)
      return (value / 1000000000).toStringAsFixed(1) + 'B';
    return (value / 1000000000000).toStringAsFixed(1) + 'T';
  }
}
