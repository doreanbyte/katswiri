import 'package:katswiri/models/job.dart';

class JobSearchMW {
  static const title = 'JobSearchMW';
  static const host = 'jobsearchmalawi.com';

  static final listingsUri = Uri.https(host, 'jm-ajax/get_listings');

  Map<String, dynamic> get _headers => {
        'Host': host,
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0',
        'X-Requested-With': 'XMLHttpRequest',
        'Origin': 'https://jobsearchmalawi.com',
        'Alt-Used': 'jobsearchmalawi.com',
        'Referer': 'https://jobsearchmalawi.com/',
      };

  Future<Job> fetchJob(String url) async {}

  Future<List<Job>> fetchJobs() async {}
}
