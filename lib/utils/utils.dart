import 'package:katswiri/models/models.dart' show Job;

DateTime postedDate(Job job) {
  var posted = job.posted.toLowerCase();
  posted = posted.replaceAll('posted', '').replaceAll('ago', '').trim();

  final period = int.tryParse(posted.split(' ').first);
  DateTime now = DateTime.now();

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
