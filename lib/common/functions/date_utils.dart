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
