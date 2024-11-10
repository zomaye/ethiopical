// TODO: Put public facing types in this file.
import 'constants.dart';

class Ethiopical {
  final int year, month, day;

  final int hour, minute, second;

  Ethiopical({
    required this.year,
    required this.month,
    required this.day,
    this.hour = 0,
    this.minute = 0,
    this.second = 0,
  }) {
    if (month < 1 || month > 13) {
      throw ArgumentError("month must be between 1 and 13");
    }

    if (month <= 12 && (day < 1 || day > 30)) {
      throw ArgumentError("Day must be between 1 and 30 for months 1-12");
    }

    if (month == 13) {
      final maxDays = _isEthiopianLeapYear(year) ? 6 : 5;
      if (day < 1 || day > maxDays) {
        throw ArgumentError('Day must be between 1 and $maxDays for month 13');
      }
    }
  }

  // Factory constructor to create an instance with today's Ethiopian date
  factory Ethiopical.today() {
    return Ethiopical.fromGregorian(DateTime.now());
  }

  // Copy constructor that takes a DateTime and returns an Ethiopical instance
  factory Ethiopical.fromDateTime(DateTime dateTime) {
    // Convert the given DateTime to an Ethiopian date
    Ethiopical ethiopianDate = Ethiopical.fromGregorian(dateTime);

    // Return a new Ethiopical instance with the time component from DateTime
    return Ethiopical(
      year: ethiopianDate.year,
      month: ethiopianDate.month,
      day: ethiopianDate.day,
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
    );
  }


  static bool _isEthiopianLeapYear(int year) {
    return year % 4 == 3;
  }

  String getMonthName() {
    return ethiopianMonths[month - 1];
  }

  String format([String pattern = 'MM dd yyyy']) {
    final dayName = _getDayName();
    final monthName = getMonthName();
    final numericMonth = month.toString().padLeft(2, '0');
    return pattern
        .replaceAll('EEE', dayName)
        .replaceAll('dd', day.toString().padLeft(2, '0'))
        .replaceAll('MMM', monthName)
        .replaceAll('MM', numericMonth)
        .replaceAll('yyyy', year.toString())
        .replaceAll('HH', hour.toString().padLeft(2, '0'))
        .replaceAll('mm', minute.toString().padLeft(2, '0'))
        .replaceAll('ss', second.toString().padLeft(2, '0'));
  }

  String _getDayName() {
    // Calculate the day of the week
    DateTime gregorianEquivalent = toGregorian();
    int weekDayIndex = gregorianEquivalent.weekday % 7;
    return ethiopianWeekDays[weekDayIndex];
  }

  @override
  String toString() {
    return format();
  }

  DateTime toGregorian() {
    // Determine the Gregorian year for the Ethiopian New Year
    int gregorianYear;
    DateTime ethiopianNewYear;

    // If the Ethiopian date is in the first half of the Ethiopian calendar year,
    // it corresponds to the previous Gregorian year before September 11.
    if (month < 4) {
      gregorianYear = year + 7; // Ethiopian year starts in the previous Gregorian year
    } else {
      gregorianYear = year + 8; // Ethiopian year aligns with the current Gregorian year
    }

    // Determine the Ethiopian New Year date in the Gregorian calendar
    if (_isEthiopianLeapYear(year - 1)) {
      ethiopianNewYear = DateTime(gregorianYear, 9, 12);
    } else {
      ethiopianNewYear = DateTime(gregorianYear, 9, 11);
    }

    // Calculate the total days from the Ethiopian New Year
    int daysIntoYear = (month - 1) * 30 + (day - 1);

    // Adjust for the 13th month
    if (month == 13) {
      daysIntoYear = 30 * 12 + (day - 1);
    }

    // Add these days to the start of the Ethiopian year to get the Gregorian date
    return ethiopianNewYear.add(Duration(days: daysIntoYear));
  }

  static Ethiopical fromGregorian(DateTime gregorianDate) {
    int ethiopianYear;

    DateTime ethiopianNewYear;

    if (gregorianDate.month > 9 || (gregorianDate.month == 9 && gregorianDate.day >= 11)) {
      ethiopianYear = gregorianDate.year - 7;
    } else {
      ethiopianYear = gregorianDate.year - 8;
    }

    if (_isEthiopianLeapYear(ethiopianYear - 1)) {
      ethiopianNewYear = DateTime(gregorianDate.year, 9, 12);
    } else {
      ethiopianNewYear = DateTime(gregorianDate.year, 9, 11);
    }

    if (gregorianDate.isBefore(ethiopianNewYear)) {
      ethiopianYear -= 1;
    }

    int dayDifference = gregorianDate.difference(ethiopianNewYear).inDays;

    int ethiopianMonth = (dayDifference ~/ 30) + 1;
    int ethiopianDay = (dayDifference % 30) + 1;

    return Ethiopical(year: ethiopianYear, month: ethiopianMonth, day: ethiopianDay);
  }

  static Ethiopical now() {
    return Ethiopical.fromGregorian(DateTime.now());
  }
}