import 'package:intl/intl.dart';

// ARCHITECTURE DECISION: Centralizing date and time parsing/formatting logic.
// Keeps UI widgets cleaner and ensures consistent localization support.

class AppDateFormatters {
  static String formatLastUpdated(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Updated today, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays == 1) {
      return 'Updated yesterday';
    } else {
      return 'Updated ${DateFormat.yMMMd().format(date)}';
    }
  }
}
