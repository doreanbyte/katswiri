import 'package:dio/dio.dart';

import 'package:katswiri/dio_request.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/base_source.dart';
import 'package:katswiri/utils/utils.dart';

class UnitedNationsCareers extends Source {
  @override
  String get title => 'UnitedNationsCareers';

  @override
  String get host => 'careers.un.org';

  Map<String, String> get _headers => {
        'Host': host,
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0',
        'Alt-Used': host,
        'Referer': 'https://$host/',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Origin': 'null',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
        'Sec-Fetch-Dest': 'document',
        'Sec-Fetch-Mode': 'navigate',
        'Sec-Fetch-Site': 'none',
        'Sec-Fetch-User': '?1',
        'DNT': '1',
        'Sec-GPC': '1',
      };

  @override
  Future<Job> fetchJob(String url) async {
    final Job job;
    final dio = DioRequest.getInstance();

    final response = await dio.get(
      url,
      options: Options(
        headers: _headers,
        responseType: ResponseType.json,
      ),
    );

    if (response.data case {'data': Map data}) {
      var datePosted = data['startDate'] as String;
      datePosted = datePosted.substring(0, datePosted.indexOf('T'));

      job = Job(
        logo:
            'https://onlinejobmw.com/wp-content/uploads/online-site-icon-100x100-1-copy.webp',
        position: data['jobTitle'],
        companyName: 'N/A',
        location: 'N/A',
        type: 'N/A',
        posted: datePosted,
        tag: getHeroTag(url),
        description: data['jobDescription'],
      );
    } else {
      job = Job.empty();
    }

    return job;
  }

  @override
  Future<List<Job>> fetchJobs({
    int page = 1,
    Map<String, String>? filter,
  }) async {
    final listingsUri =
        'https://$host/api/public/opening/jo/list/filteredV2/en';

    final List<Job> jobs = [];

    final dio = DioRequest.getInstance();
    final response = await dio.post(
      listingsUri,
      data: {
        'filterConfig': {
          'keyword': filter?['position'] ?? '',
        },
        'pagination': {
          'itemPerPage': 10,
          'page': page - 1,
          'sortBy': 'startDate',
          'sortDirection': -1,
        }
      },
      options: Options(
        headers: _headers,
        responseType: ResponseType.json,
      ),
    );

    final data = response.data;

    if (data case {'data': {'list': List listings}}) {
      for (final listing in listings) {
        final listingData = listing as Map<String, dynamic>;
        final url =
            'https://$host/api/public/opening/joV2/${listingData['jobId']}/en';
        var datePosted = listingData['startDate'] as String;
        datePosted = datePosted.substring(0, datePosted.indexOf('T'));

        jobs.add(
          Job(
            logo:
                'https://onlinejobmw.com/wp-content/uploads/online-site-icon-100x100-1-copy.webp',
            position: listingData['jobTitle'],
            companyName: 'N/A',
            location: 'N/A',
            type: 'N/A',
            posted: datePosted,
            tag: getHeroTag(url),
            url: url,
          ),
        );
      }
    }

    return jobs;
  }
}
