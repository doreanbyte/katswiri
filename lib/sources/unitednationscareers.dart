import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parseFragment;

import 'package:katswiri/dio_request.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/base_source.dart';
import 'package:katswiri/utils/utils.dart';

class UnitedNationsCareers extends Source {
  @override
  String get title => 'UnitedNationsCareers';

  @override
  String get host => 'unitednationscareers.com';

  Map<String, String> get _headers => {
        'Host': host,
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0',
        'Origin': 'https://$host',
        'Alt-Used': host,
        'Referer': 'https://$host/',
      };

  @override
  Future<Job> fetchJob(String url) async {
    final Job job;
    final dio = DioRequest.getInstance();
    final response = await dio.get<String>(
      url,
      options: Options(
        headers: _headers,
      ),
    );

    final $ = parseFragment(response.data);

    job = Job(
      logo: $
              .querySelector('.single-featured-image > img')
              ?.attributes['src']
              ?.trim() ??
          '',
      position: $.querySelector('h1.post-title')?.text.trim() ?? 'Unknown',
      companyName: 'Unknown',
      location: 'Unknown',
      type: 'Unknown',
      posted: $.querySelector('span.date.meta-item')?.text.trim() ?? 'Unknown',
      description: $
              .querySelector('div.entry-content')
              ?.outerHtml
              .replaceAll(
                  '(adsbygoogle = window.adsbygoogle || []).push({});', '')
              .trim() ??
          'Unknown',
      tag: getHeroTag(url),
    );

    return job;
  }

  @override
  Future<List<Job>> fetchJobs({
    int page = 1,
    Map<String, String>? filter,
  }) async {
    final String listingsUri = switch (filter?['position']) {
      String() => 'https://$host/?s=${filter?['position']}',
      null => 'https://$host/category/jobs/page/$page/',
    };

    final List<Job> jobs = [];

    final dio = DioRequest.getInstance();
    final response = await dio.get(
      listingsUri,
      options: Options(
        headers: _headers,
      ),
    );

    final $ = parseFragment(response.data);

    $.querySelectorAll('li.type-post').forEach((element) {
      final url =
          element.querySelector('a.more-link.button')?.attributes['href'] ?? '';

      final job = Job(
        logo: element
                .querySelector('a > .wp-post-image')
                ?.attributes['src']
                ?.trim() ??
            '',
        position:
            element.querySelector('.post-title > a')?.text.trim() ?? 'Unknown',
        companyName: 'Unknown',
        location: 'Unknown',
        type: 'Unknown',
        posted: element.querySelector('span.date.meta-item')?.text.trim() ??
            'Unknown',
        url: url,
        tag: getHeroTag(url),
      );

      jobs.add(job);
    });

    return jobs;
  }
}
