import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/screens/webview_screen.dart';
import 'package:katswiri/sources/sources.dart';
import 'package:share_plus/share_plus.dart';

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
    final iconColor = Theme.of(context).iconTheme.color;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(widget.source.title),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left_outlined,
            color: iconColor,
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
              color: iconColor,
            ),
          ),
          SaveJobButton(job: widget.job),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
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
              color: iconColor,
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
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          JobLeadSection(
            widget.job,
            initialIndex: getSources()
                .indexWhere((element) => element.title == widget.source.title),
          ),
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            labelStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            indicatorWeight: 3.0,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.white70,
            controller: _tabController,
            tabs: const [
              Tab(text: 'Description'),
              Tab(text: 'Related'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
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
      ),
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
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: const Color.fromARGB(96, 64, 64, 64),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 128.0,
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: job.url,
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
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        job.position,
                        maxLines: 3,
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
              hide: false,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                job.posted,
                style: const TextStyle(
                  color: Colors.grey,
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
  late final StreamController<Job> _streamController;

  Job _job = Job.empty();
  bool _loading = true;
  bool _hasError = false;
  String _errMsg = '';

  @override
  void initState() {
    _streamController = StreamController.broadcast();
    _streamController.stream.listen(_onData, onError: _onError);
    _job = widget.job;

    super.initState();
    _getJob();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: const Color.fromARGB(96, 64, 64, 64),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<Job>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (_loading) {
                return const Spinner();
              }

              if (_hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RetryButton(
                        onRetryPressed: _onRetryPressed,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _errMsg,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (_job.description.isNotEmpty) {
                return HtmlWidget(
                  _job.description,
                  textStyle: const TextStyle(
                    fontSize: 14.0,
                  ),
                  onTapUrl: (url) {
                    return true;
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  void _getJob() async {
    try {
      final job = await widget.source.fetchJob(_job.url);
      _streamController.sink.add(job);
    } catch (e) {
      _streamController.sink.addError(e);
    }
  }

  void _onData(Job job) {
    _job = Job(
      logo: _job.logo,
      position: _job.position,
      companyName: _job.companyName,
      location: _job.location,
      type: _job.type,
      posted: _job.posted,
      description: job.description,
    );

    setState(() {
      _loading = false;
    });
  }

  void _onError(Object error, StackTrace stackTrace) {
    setState(() {
      _loading = false;
      _hasError = true;
      _errMsg = error.toString();
    });
  }

  void _onRetryPressed() {
    setState(() {
      _hasError = false;
      _errMsg = '';
      _loading = true;
    });
    _getJob();
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
