import 'package:intl/intl.dart';

String getFormattedDate(_date) {
  var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
  var inputDate = inputFormat.parse(_date);
  var outputFormat = DateFormat('dd/MM/yyyy HH:mm');

  // Calculate time difference
  final timeDifference = DateTime.now().difference(inputDate);

  // Use formatTimeDifference for human-readable time if less than a week
  if (timeDifference.inDays < 7) {
    return formatTimeDifference(inputDate);
  } else {
    // If more than a week, use the default format
    return outputFormat.format(inputDate);
  }
}

String formatTimeDifference(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'לפני כמה רגעים';
  // } else if (difference.inMinutes < 10) {
  //   final minutes = difference.inMinutes;
  //   return "לפני $minutes דק${minutes == 1 ? 'ה' : 'ות'}";
  } else if (difference.inHours < 1) {
    final minutes = difference.inMinutes;
    return "לפני $minutes דק${minutes == 1 ? 'ה' : 'ות'}";
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    return "לפני $hours שע${hours == 1 ? 'ה' : 'ות'}";
  } else if (difference.inDays == 1) {
    return 'אתמול';
  } else if (difference.inDays < 7) {
    final days = difference.inDays;
    return "לפני $days ${days == 1 ? 'יום' : 'ימים'}";
  } else {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }
}