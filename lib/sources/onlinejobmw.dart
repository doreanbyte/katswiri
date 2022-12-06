import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parseFragment;

import 'package:katswiri/models/job.dart';

class OnlineJobMW {
  static const title = 'OnlineJobMW';
  static const host = 'onlinejobmw.com';

  static final listingsUri = Uri.https(host, 'jm-ajax/get_listings');

  static Map<String, String> get _headers => {
        'Host': host,
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0',
        'X-Requested-With': 'XMLHttpRequest',
        'Origin': 'https://onlinejobmw.com',
        'Alt-Used': 'onlinejobmw.com',
        'Referer': 'https://onlinejobmw.com/vacancies-in-malawi/',
      };

  static Future<Job> fetchJob(String url) async {
    final Job job;
    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode != 200) {
      throw HttpException('HTTP Request Error: ${response.statusCode}');
    }

    final $ = parseFragment(response.body);

    job = Job(
      logo: $.querySelector('.company_logo')?.attributes['src']?.trim() ?? '',
      position: $.querySelector('.page-title')?.text.trim() ?? '',
      companyName: $.querySelector('.job-company')?.text.trim() ?? '',
      location: $.querySelector('.location > a')?.text.trim() ?? '',
      type: $.querySelector('li.job-type')?.text.trim() ?? '',
      posted: $.querySelector('.date-posted')?.text.trim() ?? '',
      description: $
              .querySelector('.job_listing-description')
              ?.text
              .replaceAll(
                  '(adsbygoogle = window.adsbygoogle || []).push({});', '')
              .trim() ??
          '',
    );

    return job;
  }

  static Future<List<Job>> fetchJobs({page = 1}) async {
    final List<Job> jobs = [];

    final response = await http.post(
      listingsUri,
      headers: _headers,
      body: {
        'page': '$page',
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
        logo:
            element.querySelector('.company_logo')?.attributes['src']?.trim() ??
                '',
        position:
            element.querySelector('.job_listing-title')?.text.trim() ?? '',
        companyName: element
                .querySelector('.job_listing-company > strong')
                ?.text
                .trim() ??
            '',
        location:
            element.querySelector('.job_listing-location > a')?.text.trim() ??
                '',
        type: element.querySelector('li.job-type')?.text.trim() ?? '',
        posted: element.querySelector('.job_listing-date')?.text.trim() ?? '',
        url: element.querySelector('a')?.attributes['href'] ?? '',
      );

      if (!job.location.contains(RegExp('Information|Parasites'))) {
        jobs.add(job);
      }
    });

    return jobs;
  }
}
