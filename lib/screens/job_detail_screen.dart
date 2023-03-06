import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';
import 'package:share_plus/share_plus.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({
    super.key,
    required this.job,
    required this.source,
  });

  final Job job;
  final Source source;

  static const route = '/job_detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(source.title),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_outlined,
            color: Colors.blue,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Share.share(
                job.url,
                subject: job.position,
              );
            },
            icon: const Icon(
              Icons.share_sharp,
              color: Colors.blue,
            ),
          ),
          IconButton(
            onPressed: () {
              //TODO: Implement save button logic
            },
            icon: const Icon(
              Icons.bookmark_add_outlined,
              color: Colors.blue,
            ),
          ),
          IconButton(
            onPressed: () {
              //TODO: Implement opening in webview logic
            },
            icon: const Icon(
              Icons.public_outlined,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: JobDetailComponent(
          job: job,
          source: source,
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
          JobLeadSection(widget.job),
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
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.blue,
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
                  widget.job.position,
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
  const JobLeadSection(this.job, {super.key});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: const Color.fromARGB(76, 64, 64, 64),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 180.0,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    job.position,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.4,
                      wordSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Hero(
                        tag: job.url,
                        child: JobTileImage(
                          job: job,
                          size: 40,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Text(
                          job.companyName,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  JobTileTagsSection(job),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        job.posted,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
  bool _loading = false;
  bool _hasError = false;

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
                      IconButton(
                        onPressed: _onRetryPressed,
                        icon: const Icon(Icons.refresh),
                        color: Colors.blue,
                        iconSize: 38.0,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Something went wrong',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (_job.description.isNotEmpty) {
                return HtmlWidget(
                  _job.description,
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                  ),
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
      setState(() {
        _loading = true;
      });

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
    _loading = false;
    setState(() {
      _hasError = true;
      _getJob();
    });
  }

  void _onRetryPressed() {
    _hasError = false;
    _getJob();
  }
}

class RelatedSection extends StatelessWidget {
  const RelatedSection(this.position, this.source, {super.key});

  final String position;
  final Source source;

  @override
  Widget build(BuildContext context) {
    return JobListRetriever(
      source: source,
      arguments: {'position': position},
    );
  }
}
