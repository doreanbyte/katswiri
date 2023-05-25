/// [postedDate] takes a [String] and checks the posted field and converts it to its
/// [DateTime] equivalent such that given a posted date of say 6 hours it will
/// try to find and evaluate it to the [DateTime] presentation
DateTime postedDate(String posted) {
  posted = posted.toLowerCase();
  posted = posted
      .replaceAll('posted', '')
      .replaceAll('ago', '')
      .replaceAll('on', '')
      .trim();

  final dateRE = RegExp(r'^(?<month>\w+)\s(?<day>\d{1,2}),\s(?<year>\d{4})$');
  final dateMatch = dateRE.firstMatch(posted);

  DateTime now = DateTime.now();

  if (dateMatch != null) {
    int month = _getMonthNumber(dateMatch.namedGroup('month') as String);
    int day = int.parse(dateMatch.namedGroup('day') as String);
    int year = int.parse(dateMatch.namedGroup('year') as String);

    final datePosted = DateTime(year, month, day);
    return datePosted;
  }

  final period = int.tryParse(posted.split(' ').first);

  if (period == null) {
    return now;
  }

  DateTime difference;

  if (posted.contains('sec')) {
    difference = now.subtract(
      Duration(seconds: period),
    );
  } else if (posted.contains('min')) {
    difference = now.subtract(
      Duration(minutes: period),
    );
  } else if (posted.contains('hour')) {
    difference = now.subtract(
      Duration(hours: period),
    );
  } else if (posted.contains('day')) {
    difference = now.subtract(
      Duration(days: period),
    );
  } else if (posted.contains('week')) {
    difference = now.subtract(
      Duration(days: period * 7),
    );
  } else if (posted.contains('month')) {
    difference = now.subtract(
      Duration(days: period * 30),
    );
  } else if (posted.contains('year')) {
    difference = now.subtract(
      Duration(days: period * 365),
    );
  } else {
    difference = now;
  }

  return difference;
}

int _getMonthNumber(String monthName) {
  final months = [
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december'
  ];

  final monthIndex = months.indexOf(monthName);
  return monthIndex + 1;
}

/// [getTimeAgo] given [dateTime] return the [String] presentation in the format
/// "{time} {duration} ago" where {duration} can be in seconds, minutes, hours
/// etc.
String getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }
}
