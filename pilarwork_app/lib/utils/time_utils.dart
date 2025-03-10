import 'package:intl/intl.dart';

class TimeUtils {
  static String localTimeZone() {
    return DateTime.now().timeZoneName;
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
}
