import 'package:intl/intl.dart';

String formatDate(String? dateString) {
  if (dateString != null) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd').format(dateTime); // Format date
  }
  return '';
}

String formatToDateTime(String? dateString) {
  if (dateString != null) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd').format(dateTime); // Format date
  }
  return '';
}

String formatDateTime(DateTime? dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime!); // Format date
}

int calculateAge(DateTime dateOfBirth) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - dateOfBirth.year;
  int month1 = currentDate.month;
  int month2 = dateOfBirth.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = dateOfBirth.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}
