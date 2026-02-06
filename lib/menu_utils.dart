// import 'dart:developer' as developer;

extension StringExtension on String {
  String takeLast(int n) {
    if (length <= n) return this;
    return substring(length - n);
  }
}
