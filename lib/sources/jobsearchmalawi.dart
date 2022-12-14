import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parseFragment;

import 'package:katswiri/models/job.dart';
import 'package:katswiri/sources/base_source.dart';

class JobSearchMW extends Source {
  @override
  String get title => 'JobSearchMW';

  static const host = 'jobsearchmalawi.com';

  static final listingsUri = Uri.https(host, 'jm-ajax/get_listings');

  static Map<String, String> get _headers => {
        'Host': host,
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0',
        'X-Requested-With': 'XMLHttpRequest',
        'Origin': 'https://jobsearchmalawi.com',
        'Alt-Used': 'jobsearchmalawi.com',
        'Referer': 'https://jobsearchmalawi.com/',
      };

  @override
  Future<Job> fetchJob(String url) async {
    final Job job;
    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode != 200) {
      throw HttpException('HTTP Request Error: ${response.statusCode}');
    }

    final $ = parseFragment(response.body);

    job = Job(
      logo: $.querySelector('.wp-post-image')?.attributes['src']?.trim() ?? '',
      position: $.querySelector('.entry-title')?.text.trim() ?? '',
      companyName: $.querySelector('p.name > strong')?.text.trim() ?? '',
      location: $.querySelector('.location > a')?.text.trim() ?? '',
      type: $.querySelector('li.job-type')?.text.trim() ?? '',
      posted: $.querySelector('.date-posted > time')?.text.trim() ?? '',
      description: $
              .querySelector('.job_description')
              ?.text
              .replaceAll(
                  '(adsbygoogle = window.adsbygoogle || []).push({});', '')
              .trim() ??
          '',
    );

    return job;
  }

  @override
  Future<List<Job>> fetchJobs({
    int page = 1,
    Map<String, String>? arguments,
  }) async {
    final List<Job> jobs = [];

    final response = await http.post(
      listingsUri,
      headers: _headers,
      body: {
        'page': '$page',
        'per_page': '20',
        'orderby': 'featured',
        'order': 'DESC',
        'show_pagination': 'false',
        if (arguments?['position'] != null)
          'search_keywords': arguments?['position'],
      },
    );

    if (response.statusCode != 200) {
      throw HttpException('HTTP Request Error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body);
    final html = json['html'];
    final $ = parseFragment(html);

    $.querySelectorAll('li.job_listing').forEach((element) {
      final job = Job(
        logo: element
                .querySelector('img.company_logo')
                ?.attributes['src']
                ?.trim() ??
            '',
        position: element.querySelector('.position > h3')?.text.trim() ?? '',
        companyName:
            element.querySelector('.company > strong')?.text.trim() ?? '',
        location: element.querySelector('.location')?.text.trim() ?? '',
        type: element.querySelector('li.job-type')?.text.trim() ?? '',
        posted: element.querySelector('.date > time')?.text.trim() ?? '',
        url: element.querySelector('a')?.attributes['href'] ?? '',
      );

      if (!job.location.contains(RegExp('Information|Parasites'))) {
        jobs.add(job);
      }
    });

    return jobs;
  }
}
