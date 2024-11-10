import 'dart:math';

import 'package:ethiopical/src/extensions.dart';
import 'package:test/test.dart';
import 'package:ethiopical/ethiopical.dart';

void main() {
  group('Ethiopical', () {
    test('should throw ArgumentError for invalid month', () {
      expect(() => Ethiopical(year: 2015, month: 14, day: 1), throwsArgumentError);
      expect(() => Ethiopical(year: 2015, month: 0, day: 1), throwsArgumentError);
    });

    test('should throw ArgumentError for invalid day in months 1-12', () {
      expect(() => Ethiopical(year: 2015, month: 1, day: 31), throwsArgumentError);
      expect(() => Ethiopical(year: 2015, month: 1, day: 0), throwsArgumentError);
    });

    test('should throw ArgumentError for invalid day in month 13', () {
      expect(() => Ethiopical(year: 2014, month: 13, day: 6), throwsArgumentError);
      expect(() => Ethiopical(year: 2015, month: 13, day: 7), throwsArgumentError);
    });

    test('should create valid Ethiopical date', () {
      final date = Ethiopical(year: 2015, month: 1, day: 1);
      expect(date.year, 2015);
      expect(date.month, 1);
      expect(date.day, 1);
    });

    test('should convert Gregorian date to Ethiopian date', () {
      final gregorianDate = DateTime(2024, 11, 10);
      final ethiopianDate = Ethiopical.fromGregorian(gregorianDate);
      expect(ethiopianDate.year, 2017);
      expect(ethiopianDate.month, 3);
      expect(ethiopianDate.day, 1);
    });

    test('should return correct month name', () {
      final date = Ethiopical(year: 2015, month: 1, day: 1);
      expect(date.getMonthName(), 'መስከረም');
    });

    test('should format date correctly', () {
      final date = Ethiopical(year: 2017, month: 3, day: 1);
      expect(date.format(), '03 01 2017');
      expect(date.format('dd-MMM-yyyy'), '01-ኅዳር-2017');
      expect(date.format('EEE MMM dd yyyy'), 'እሑድ ኅዳር 01 2017');
      expect(date.format('EEE MMM dd yyyy HH:mm:ss'), 'እሑድ ኅዳር 01 2017 00:00:00');

    });

    test('should return current Ethiopian date', () {
      final now = DateTime.now();
      final ethiopianNow = Ethiopical.now();
      final expectedEthiopianNow = Ethiopical.fromGregorian(now);
      expect(ethiopianNow.year, expectedEthiopianNow.year);
      expect(ethiopianNow.month, expectedEthiopianNow.month);
      expect(ethiopianNow.day, expectedEthiopianNow.day);
    });

    test('should convert DateTime to Ethiopian date using extension', () {
      final gregorianDate = DateTime(2024, 11, 10);
      final ethiopianDate = gregorianDate.toEthiopian();
      expect(ethiopianDate.year, 2017);
      expect(ethiopianDate.month, 3);
      expect(ethiopianDate.day, 1);
    });
    test('should return correct Gregorian date', () {
      final ethiopianDate = Ethiopical(year: 2017, month: 3, day: 1);
      final gregorianDate = ethiopianDate.toGregorian();
      expect(gregorianDate.day, 9);
      expect(gregorianDate.month, 11);
      expect(gregorianDate.year, 2024);
    });

    test('should return correct Gregorian date for leap year', () {
      final ethiopianDate = Ethiopical(year: 2018, month: 1, day: 1);
      final gregorianDate = ethiopianDate.toGregorian();
      expect(gregorianDate.day, 11);
      expect(gregorianDate.month, 9);
      expect(gregorianDate.year, 2025);
    });
    test('should convert Ethiopian date to Gregorian date correctly', () {
      final ethiopianDate = Ethiopical(year: 2017, month: 3, day: 1);
      final gregorianDate = ethiopianDate.toGregorian();
      expect(gregorianDate.day, 9);
      expect(gregorianDate.month, 11);
      expect(gregorianDate.year, 2024);

      final ethiopianDate2 = Ethiopical(year: 2018, month: 1, day: 1);
      final gregorianDate2 = ethiopianDate2.toGregorian();
      expect(gregorianDate2.day, 11);
      expect(gregorianDate2.month, 9);
      expect(gregorianDate2.year, 2025);
    });

    test('ethiopian leap year', () {
      final ethiopianDate3 = Ethiopical(year: 2015, month: 13, day: 6);
      final gregorianDate3 = ethiopianDate3.toGregorian();
      expect(gregorianDate3.day, 10);
      expect(gregorianDate3.month, 9);
      expect(gregorianDate3.year, 2024);
    });

  });
}