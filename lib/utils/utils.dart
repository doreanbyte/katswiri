import 'package:katswiri/models/models.dart' show Job;

DateTime postedDate(Job job) {
  var posted = job.posted.toLowerCase();
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

  if (posted.contains('sec')) {
    return now.subtract(
      Duration(seconds: period),
    );
  } else if (posted.contains('min')) {
    return now.subtract(
      Duration(minutes: period),
    );
  } else if (posted.contains('hour')) {
    return now.subtract(
      Duration(hours: period),
    );
  } else if (posted.contains('day')) {
    return now.subtract(
      Duration(days: period),
    );
  } else if (posted.contains('week')) {
    return now.subtract(
      Duration(days: period * 7),
    );
  } else if (posted.contains('month')) {
    return now.subtract(
      Duration(days: period * 30),
    );
  } else if (posted.contains('year')) {
    return now.subtract(
      Duration(days: period * 365),
    );
  } else {
    return now;
  }
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
