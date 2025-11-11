import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class DateHelper {
  static String formatDateWMY(DateTime date) {
    final day = toBeginningOfSentenceCase(DateFormat.d().format(date));
    final month = toBeginningOfSentenceCase(DateFormat.MMM().format(date));
    final year = DateFormat('y').format(date);
    return '$day de $month $year';
  }

  /// 21 Sept 2025 10:30 PM
  static String formatFullDateTime(DateTime? date) {
    if (date == null) return '';
    final day = DateFormat('d').format(date);
    final month = toBeginningOfSentenceCase(
      DateFormat('MMM', 'es').format(date),
    );
    final year = DateFormat('y').format(date);
    final timeOfDay = TimeOfDay.fromDateTime(date);
    final formattedTime = formatTimeOfDay(timeOfDay);
    return '$day $month $year $formattedTime';
  }

  /// Formatea un TimeOfDay a string legible, ejemplo: "10:30 PM"
  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Convierte un string como "10:30 PM" o "22:15" en un TimeOfDay
  static TimeOfDay? parseTimeOfDay(String input) {
    final cleaned = input.trim().toUpperCase();

    // 🕒 Formato 12 horas: "10:30 PM" o "7:05 AM"
    final regex12h = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$');
    final match12h = regex12h.firstMatch(cleaned);
    if (match12h != null) {
      var hour = int.parse(match12h.group(1)!);
      final minute = int.parse(match12h.group(2)!);
      final period = match12h.group(3);

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return TimeOfDay(hour: hour, minute: minute);
    }

    // ⏰ Formato 24 horas: "22:30" o "07:15"
    final regex24h = RegExp(r'^(\d{1,2}):(\d{2})$');
    final match24h = regex24h.firstMatch(cleaned);
    if (match24h != null) {
      final hour = int.parse(match24h.group(1)!);
      final minute = int.parse(match24h.group(2)!);
      if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
        return TimeOfDay(hour: hour, minute: minute);
      }
    }

    // ❌ Si no coincide con ninguno
    return null;
  }
}
