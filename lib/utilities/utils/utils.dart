import 'package:intl/intl.dart';

bool isNumeric(String str) {
  return double.tryParse(str) != null;
}

String formatMillisecondsSinceEpochToDateString(int millisecondsSinceEpoch) {
  // Convert milliseconds to DateTime
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

  // Format the date using intl package
  final DateFormat formatter = DateFormat('MMM dd, yyyy - HH:mm');
  final String formattedDate = formatter.format(dateTime);

  return formattedDate;
}

int formatDateStringMillisecondsSinceEpoch(String dateString) {
  // Create a DateFormat that matches your input format
  final DateFormat formatter = DateFormat('MMM dd, yyyy - HH:mm');

  try {
    // Parse the string to DateTime
    final DateTime dateTime = formatter.parse(dateString);

    // Convert DateTime to millisecondsSinceEpoch
    return dateTime.millisecondsSinceEpoch;
  } catch (e) {
    // Handle invalid date format
    print('Error parsing date: $e');
    return 0; // Or throw an exception depending on your error handling strategy
  }
}