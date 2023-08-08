import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parseFragment;
import 'package:html/dom.dart' show DocumentFragment;

import 'package:katswiri/dio_request.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/base_source.dart';
import 'package:katswiri/sources/source_countries.dart';
import 'package:katswiri/utils/utils.dart';

class OnlineJobMW extends Source {
  @override
  String get title => 'OnlineJobMW';

  @override
  String get host => 'onlinejobmw.com';

  @override
  Countries get country => Countries.malawi;

  Map<String, String> get _headers => {
        'Host': host,
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0',
        'X-Requested-With': 'XMLHttpRequest',
        'Origin': 'https://onlinejobmw.com',
        'Alt-Used': 'onlinejobmw.com',
        'Referer': 'https://onlinejobmw.com/job-vacancies/',
      };

  @override
  Future<Job> fetchJob(String url) async {
    final Job job;
    final dio = DioRequest.getInstance();
    final response = await dio.get<String>(
      url,
      options: Options(
        headers: {
          ..._headers,
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
          'Sec-Fetch-Dest': 'document',
          'Sec-Fetch-Mode': 'navigate',
          'Sec-Fetch-Site': 'none',
          'Sec-Fetch-User': '?1',
          'Sec-GPC': '1',
        },
      ),
    );

    final $ = parseFragment(response.data);

    final jobDetails = $
        .querySelectorAll('.jet-listing-dynamic-field__content')
        .take(5)
        .toList();

    job = Job(
      logo: $
              .querySelector('.elementor-image > img')
              ?.attributes['src']
              ?.trim() ??
          '',
      position: jobDetails.elementAtOrNull(0)?.text.trim() ?? 'Unknown',
      companyName: $.querySelector('h2.elementor-heading-title')?.text.trim() ??
          'Unknown',
      location: jobDetails.elementAtOrNull(3)?.text.trim() ?? 'Unknown',
      type: jobDetails.elementAtOrNull(1)?.text.trim() ?? 'Unknown',
      posted: jobDetails.elementAtOrNull(2)?.text ?? 'Unknown',
      description: $
              .querySelectorAll('.elementor-element.e-flex.e-con-boxed.e-con')
              .elementAtOrNull(1)
              ?.text
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
    final listingsUri = 'https://$host/job-vacancies/';
    List<Job> jobs = [];

    final dio = DioRequest.getInstance();

    if (page == 1) {
      final response = await dio.get<String>(
        listingsUri,
        options: Options(headers: _headers),
      );

      final html = response.data as String;
      final $ = parseFragment(html);
      jobs = _extractListings($);
    } else {
      final response = await dio.post<Map<String, dynamic>>(
        listingsUri,
        options: Options(
          headers: {
            ..._headers,
            'Referer': 'https://onlinejobmw.com/job-vacancies/'
          },
        ),
        data: FormData.fromMap(
          {
            'action': 'jet_engine_ajax',
            'handler': 'listing_load_more',
            'query[post_status][]': 'publish',
            'query[post_type]': 'vacancies',
            'query[posts_per_page]': '8',
            'query[paged]': '1',
            'query[ignore_sticky_posts]': '1',
            'query[suppress_filters]': 'false',
            'query[jet_smart_filters]': 'jet-engine/default',
            'widget_settings[lisitng_id]': '95',
            'widget_settings[posts_num]': '8',
            'widget_settings[columns]': '1',
            'widget_settings[columns_tablet]': '1',
            'widget_settings[columns_mobile]': '1',
            'widget_settings[is_archive_template]': '',
            'widget_settings[post_status][]': 'publish',
            'widget_settings[use_random_posts_num]': '',
            'widget_settings[max_posts_num]': '9',
            'widget_settings[not_found_message]': 'No+data+was+found',
            'widget_settings[is_masonry]': 'false',
            'widget_settings[equal_columns_height]': '',
            'widget_settings[use_load_more]': 'yes',
            'widget_settings[load_more_id]': 'load_more',
            'widget_settings[load_more_type]': 'scroll',
            'widget_settings[load_more_offset][unit]': 'px',
            'widget_settings[load_more_offset][size]': '0',
            'widget_settings[use_custom_post_types]': '',
            'widget_settings[hide_widget_if]': '',
            'widget_settings[carousel_enabled]': '',
            'widget_settings[slides_to_scroll]': '1',
            'widget_settings[arrows]': 'true',
            'widget_settings[arrow_icon]': 'fa+fa-angle-left',
            'widget_settings[dots]': '',
            'widget_settings[autoplay]': 'true',
            'widget_settings[autoplay_speed]': '5000',
            'widget_settings[infinite]': 'true',
            'widget_settings[center_mode]': '',
            'widget_settings[effect]': 'slide',
            'widget_settings[speed]': '500',
            'widget_settings[inject_alternative_items]': '',
            'widget_settings[scroll_slider_enabled]': '',
            'widget_settings[scroll_slider_on][]': [
              'desktop',
              'tablet',
              'mobile'
            ],
            'widget_settings[custom_query]': 'false',
            'widget_settings[custom_query_id]': '',
            'widget_settings[_element_id]': '',
            'page_settings[post_id]': 'false',
            'page_settings[queried_id]': 'false',
            'page_settings[element_id]': 'false',
            'page_settings[page]': '$page',
            'listing_type': 'false',
            'isEditMode': 'false',
            'addedPostCSS[]': '95'
          },
        ),
      );

      final json = response.data as Map<String, dynamic>;

      if (json case {'data': {'html': String html}}) {
        final $ = parseFragment(html);
        jobs = _extractListings($);
      }
    }

    return jobs;
  }

  List<Job> _extractListings(DocumentFragment $) {
    final List<Job> jobs = [];

    $.querySelectorAll('div.jet-listing-grid__item').forEach(
      (element) {
        final details = element
            .querySelectorAll(
                '.elementor-widget-container .jet-listing-dynamic-field__content')
            .take(3)
            .toList();

        final url = element
                .querySelector('div.jet-engine-listing-overlay-wrap')
                ?.attributes['data-url'] ??
            '';

        final job = Job(
          logo: element
                  .querySelector('div.elementor-image > img')
                  ?.attributes['src']
                  ?.trim() ??
              '',
          position: details.elementAtOrNull(0)?.text ?? 'Unknown',
          companyName: details.elementAtOrNull(1)?.text ?? 'Unknown',
          location: element
                  .querySelector('li span.elementor-icon-list-text')
                  ?.text
                  .trim() ??
              'Unknown',
          type: element
                  .querySelector(
                      '.elementor-widget-container a.jet-listing-dynamic-terms__link')
                  ?.text
                  .trim() ??
              'Unknown',
          posted: details.elementAtOrNull(2)?.text ?? 'Unknown',
          url: url,
          tag: getHeroTag(url),
        );

        if (!job.location.contains(RegExp('Information|Parasites'))) {
          jobs.add(job);
        }
      },
    );

    return jobs;
  }
}
