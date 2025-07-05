abstract final class StringUtils {
  /// capitalize the first letter of the text
  static String capitalize(String text) {
    return text.length > 1
        ? '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}'
        : text.toUpperCase();
  }

  /// capitalize the first letter of each word in the text
  static String capitalizeEachWord(String text) {
    if (text.isEmpty) {
      return '';
    }

    final words = text.split(' ');
    final capitalizedWords = words
        .map((word) {
          if (word.isEmpty) {
            return '';
          }

          return capitalize(word);
        })
        .join(' ');

    return capitalizedWords;
  }

  /// check if text is null or empty
  static bool isNullOrEmpty(String? s) {
    return s == null || s.trim().isEmpty;
  }
}
