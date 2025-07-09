abstract final class DateFormatUtils {
  static String formatDateAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays >= 365) {
        final years = difference.inDays ~/ 365;
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays >= 30) {
        final months = difference.inDays ~/ 30;
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays >= 7) {
        final weeks = difference.inDays ~/ 7;
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
