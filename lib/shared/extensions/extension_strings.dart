import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension CustomExtension on String {
  DateTime toDateTime() {
    return DateFormat("dd/MM/yyyy").parse(this);
  }

  DateTime get toDateTimeByUTC {
    return DateTime.parse(this);
  }

  String get toDateWithDay {
    final date = DateTime.tryParse(this);
    if (date == null) return this;
    final format = DateFormat(
      "EEE, dd/MM",
      Locale(Intl.defaultLocale!).languageCode,
    );
    return format.format(date);
  }

  String get toStation {
    return split("- ").last;
  }

  String get toSimpleDateWithDay {
    final date = DateTime.tryParse(this);
    if (date == null) return this;
    final format = DateFormat(
      "EEE, dd/MM/yy",
      Locale(Intl.defaultLocale!).languageCode,
    );
    return format.format(date);
  }

  String get toDate {
    final date = DateTime.tryParse(this);
    if (date == null) return this;
    final format = DateFormat("dd/MM/yyyy");
    return format.format(date);
  }

  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String get capitalizeAllFirst {
    return split(" ").map((e) => e.capitalizeFirst).join(" ");
  }

  String get toSimpleDate {
    final date = DateTime.tryParse(this);
    if (date == null) return this;
    final format = DateFormat("dd/MM/yy");
    return format.format(date);
  }

  String get toDaysOfWeekUpperCase {
    final daySeparated = split("-");
    if (daySeparated.length < 2) {
      return substring(0, 1).toUpperCase() + substring(1);
    } else {
      return "${daySeparated.first.substring(0, 1).toUpperCase()}${daySeparated.first.substring(1)}-${daySeparated.last.substring(0, 1).toUpperCase()}${daySeparated.last.substring(1)}";
    }
  }
}

extension CustomExtensionNullSafety on String {
  DateTime toDateTime() {
    return DateFormat("dd/MM/yyyy").parse(this);
  }

  DateTime? toCompleteDateTime() {
    return DateTime.tryParse(this);
  }
}

extension CustomExtensionCurrency on double? {
  String toCurrency() {
    return "R\$ ${NumberFormat("#,##0.00", "pt_BR").format(this)}";
  }
}

extension CustomExtensionInt on int {
  String get toHourAndMinuteText {
    final hours = (this / 60).floor();
    final minutes = this % 60;

    if (hours == 0) {
      return "${minutes}min";
    } else if (hours < 0) {
      return "0min";
    }

    return "${hours}h${minutes}min";
  }
}

extension CustomExtensionInitialLetter on String {
  String toInitialLetters() {
    final List<String> names = trim().split(' ');
    if (names.length > 1) {
      return names.first.substring(0, 1).toUpperCase() + names.last.substring(0, 1).toUpperCase();
    }
    if (names.first.isEmpty) return this;
    return names.first.substring(0, 1).toUpperCase();
  }

  String toInitialTwoLetters() {
    final List<String> names = trim().split(' ');
    if (names.length > 1) {
      return names.first.substring(0, 1).toUpperCase() + names[1].substring(0, 1).toUpperCase();
    }
    if (names.first.isEmpty) return this;
    return names.first.substring(0, 1).toUpperCase();
  }

  String get toFirstName {
    final List<String> names = trim().split(' ');
    if (names.length > 1) {
      return names.first;
    }
    if (names.first.isEmpty) return this;
    return names.first;
  }
}

extension CustomExtensionDateToString on DateTime {
  String dateToString() {
    return DateFormat("dd/MM/yyyy").format(this);
  }
}

extension CustomExtensionNullableDateToString on DateTime? {
  String get toHourAndMinute {
    final format = DateFormat(
      "HH:mm",
      Locale(Intl.defaultLocale!).languageCode,
    );
    return this == null ? "" : format.format(this!);
  }

  String get toCheckInTimeReserveDetails {
    if (this == null) return "";
    final date = this!.subtract(const Duration(hours: 3));
    return date.toHourAndMinute;
  }

  String get toDateAndDay {
    final format = DateFormat(
      "EEE, dd/MM",
      Locale(Intl.defaultLocale!).languageCode,
    );
    final date = this == null ? "" : format.format(this!);
    return date.capitalizeFirst != null ? date.capitalizeFirst!.replaceFirst('.', '') : date;
  }

  String get toMonth {
    final format = DateFormat(
      "MMM",
      Locale(Intl.defaultLocale!).languageCode,
    );

    final date = this == null ? "" : format.format(this!);
    return date.toUpperCase().replaceFirst('.', '');
  }

  String get toDayAndMonth {
    final format = DateFormat(
      "dd/MM",
      Locale(Intl.defaultLocale!).languageCode,
    );
    return this == null ? "" : format.format(this!);
  }
}