import 'package:aplikasitask/common/info_tanggal.dart';
import 'package:aplikasitask/constants/constants.dart';
import 'package:sprintf/sprintf.dart';

class CoreUtils {
  static List<Infotanggal> getWeek() {
    final now = DateTime.now();

    final year = now.year;
    final month = now.month;
    final day = now.day;

    final today = DateTime(year, month, day);
    final mondayOfThatWeek = today.add(Duration(days: 1 - today.weekday));

    List<Infotanggal> dateTimes = [];
    for (int i = 0; i < 7; i++) {
      final tempDate =
          removeTimeComponent(mondayOfThatWeek.add(Duration(days: i)));

      dateTimes.add(Infotanggal(
          dayName: getWeekDay(tempDate),
          dateType: getDateType(tempDate, today),
          dateTime: tempDate));
    }

    return dateTimes;
  }

  static String getWeekDay(DateTime dateTime) {
    switch (dateTime.weekday) {
      case DateTime.monday:
        return "senin";
      case DateTime.tuesday:
        return "selasa";
      case DateTime.wednesday:
        return "rabu";
      case DateTime.thursday:
        return "kamis";
      case DateTime.friday:
        return "jumat";
      case DateTime.saturday:
        return "Sabtu";
      case DateTime.sunday:
        return "minggu";
      default:
        throw "Invalid Weekday";
    }
  }

  static DateType getDateType(DateTime dateTime1, DateTime dateTime2) {
    int value = dateTime1.compareTo(dateTime2);
    if (value == 0) {
      return DateType.TODAY;
    } else {
      return value < 0 ? DateType.PAST_DATE : DateType.FUTURE_DATE;
    }
  }

  static String getDateInDDMMYYYY(DateTime dateTime) {
    assert(dateTime != null);

    return sprintf("%02d", [dateTime.day]) +
        "-" +
        sprintf("%02d", [dateTime.month]) +
        "-" +
        dateTime.year.toString();
  }

  static DateTime removeTimeComponent(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
