import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:share_plus/share_plus.dart';
import 'package:katswiri/bloc/bloc.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/screens/webview_screen.dart';
import 'package:katswiri/sources/sources.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({
    super.key,
    required this.job,
    required this.source,
  });

  final Job job;
  final Source source;

  static const route = '/job_detail';

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            labelStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            indicatorWeight: 3.0,
            tabs: [
              Tab(text: 'DESCRIPTION'),
              Tab(text: 'RELATED'),
            ],
          ),
          title: Text(
            widget.source.title,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await Share.share(
                  widget.job.url,
                  subject: widget.job.position,
                );
              },
              icon: Icon(
                Icons.share_sharp,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            SaveJobButton(job: widget.job),
            IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(
                  context,
                  WebViewScreen.route,
                  arguments: {
                    'url': widget.job.url,
                    'title': widget.job.position,
                  },
                );
              },
              icon: Icon(
                Icons.public_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: JobDetailComponent(
            job: widget.job,
            source: widget.source,
          ),
        ),
      ),
    );
  }
}

class JobDetailComponent extends StatefulWidget {
  const JobDetailComponent({
    super.key,
    required this.job,
    required this.source,
  });

  final Job job;
  final Source source;

  @override
  State<JobDetailComponent> createState() => _JobDetailComponentState();
}

class _JobDetailComponentState extends State<JobDetailComponent>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            children: [
              DescriptionSection(
                widget.job,
                widget.source,
              ),
              RelatedSection(
                {'position': widget.job.position},
                widget.source,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class JobLeadSection extends StatelessWidget {
  const JobLeadSection(
    this.job, {
    required this.initialIndex,
    super.key,
  });

  final Job job;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 138.0,
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: job.tag as Object,
                  child: JobThumbnailImage(
                    job: job,
                    size: 36.0,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.companyName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        job.position,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.4,
                          wordSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            JobTagsSection(
              job,
              initialIndex: initialIndex,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                job.posted,
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DescriptionSection extends StatefulWidget {
  const DescriptionSection(this.job, this.source, {super.key});

  final Job job;
  final Source source;

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection>
    with AutomaticKeepAliveClientMixin<DescriptionSection> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        _getJob(context);
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            JobLeadSection(
              widget.job,
              initialIndex: getSources().indexWhere(
                  (element) => element.title == widget.source.title),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocProvider(
                  create: (_) => JobDescriptionBloc()
                    ..add(
                      FetchJobDescription(
                        job: widget.job,
                        source: widget.source,
                      ),
                    ),
                  child: BlocConsumer<JobDescriptionBloc, JobDescriptionState>(
                    listener: (context, jobDescriptionState) {},
                    builder: (context, jobDescriptionState) {
                      return switch (jobDescriptionState) {
                        JobDescriptionLoaded(job: final job) => switch (
                              job.description.isNotEmpty) {
                            true => HtmlWidget(
                                job.description,
                                textStyle: const TextStyle(
                                  fontSize: 14.0,
                                ),
                                onTapUrl: (url) async {
                                  url = url
                                      .replaceAll(RegExp('mailto:'), '')
                                      .trim();
                                  if (url.contains('@')) {
                                    final emailUri = Uri(
                                      scheme: 'mailto',
                                      path: url,
                                      query: _encodeQueryParameters(
                                        {
                                          'subject': widget.job.position,
                                        },
                                      ),
                                    );

                                    if (await canLaunchUrl(emailUri)) {
                                      await launchUrl(emailUri);
                                    }
                                  }

                                  return true;
                                },
                              ),
                            _ => Container()
                          },
                        JobDescriptionError(error: final error) => Center(
                            child: ErrorButton(
                              errorMessage: error,
                              onRetryPressed: () => _onRetryPressed(context),
                            ),
                          ),
                        _ => const Center(
                            child: CircularProgressIndicator(),
                          ),
                      };
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Send [FetchJobDescription] to [JobDescriptionBloc] to get job description
  void _getJob(BuildContext context) {
    context.read<JobDescriptionBloc>().add(
          FetchJobDescription(
            job: widget.job,
            source: widget.source,
          ),
        );
  }

  void _onRetryPressed(BuildContext context) {
    _getJob(context);
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}

class RelatedSection extends StatelessWidget {
  const RelatedSection(this.filter, this.source, {super.key});

  final Map<String, String>? filter;
  final Source source;

  @override
  Widget build(BuildContext context) {
    return JobListRetriever(
      source: source,
      filter: filter,
    );
  }
}
