import 'ethiopical_base.dart';

/// Extension method for DateTime to convert to Ethiopian date
extension EthiopianDateTimeExtension on DateTime {
  Ethiopical toEthiopian() {
    return Ethiopical.fromGregorian(this);
  }
}
