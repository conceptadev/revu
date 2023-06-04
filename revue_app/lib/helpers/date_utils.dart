import 'package:intl/intl.dart';

String timeAgo(DateTime? dateTime) {
  final now = DateTime.now();
  if (dateTime == null) {
    return 'N/A';
  }
  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return '$years year${years == 1 ? '' : 's'} ago';
  } else if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months == 1 ? '' : 's'} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else {
    return 'Just now';
  }
}

String friendlyDate(DateTime? dateTime) {
  String daySuffix(int day) {
    if (day < 1) return '';
    if (day % 100 >= 11 && day % 100 <= 13) {
      return 'th';
    }

    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  if (dateTime == null) {
    return 'N/A';
  }

  final dateFormatter = DateFormat("EEE, MMM d");
  final yearFormatter = DateFormat("y");
  final formattedDate = dateFormatter.format(dateTime);
  final formattedYear = yearFormatter.format(dateTime);

  return '$formattedDate${daySuffix(dateTime.day)}, $formattedYear';
}
