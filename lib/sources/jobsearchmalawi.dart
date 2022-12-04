import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parseFragment;

import 'package:katswiri/models/job.dart';

class JobSearchMW {
  static const title = 'JobSearchMW';
  static const host = 'jobsearchmalawi.com';

  static final listingsUri = Uri.https(host, 'jm-ajax/get_listings');

  Map<String, String> get _headers => {
        'Host': host,
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0',
        'X-Requested-With': 'XMLHttpRequest',
        'Origin': 'https://jobsearchmalawi.com',
        'Alt-Used': 'jobsearchmalawi.com',
        'Referer': 'https://jobsearchmalawi.com/',
      };

  Future<Job> fetchJob(String url) async {
    final Job job;
    final url = listingsUri;

    final response = await http.post(url, headers: _headers);

    if (response.statusCode != 200) {
      throw HttpException('HTTP Request completed with ${response.statusCode}');
    }

    final json = jsonDecode(response.body);
    final $ = parseFragment(json['html']);

    job = Job(
      logo: $.querySelector('.company_logo')?.attributes['src']?.trim() ?? '',
      position: $.querySelector('.entry-title')?.text.trim() ?? '',
      companyName: $.querySelector('p.name > strong')?.text.trim() ?? '',
      location: $.querySelector('.location > a')?.text.trim() ?? '',
      type: $.querySelector('li.job-type')?.text.trim() ?? '',
      posted: $.querySelector('.date-posted > time')?.text.trim() ?? '',
      description: $.querySelector('.job_description')?.text.trim() ?? '',
    );

    return job;
  }

  Future<List<Job>> fetchJobs() async {}
}
