import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:katswiri/models/job.dart';
import 'package:katswiri/sources/sources.dart';

class JobDetailSection extends StatefulWidget {
  const JobDetailSection({
    super.key,
    required this.job,
    required this.source,
  });

  final Job job;
  final Source source;

  @override
  State<JobDetailSection> createState() => _JobDetailSectionState();
}

class _JobDetailSectionState extends State<JobDetailSection>
    with AutomaticKeepAliveClientMixin<JobDetailSection> {
  Job _job = Job.empty();
  late final Source _source;
  bool _loading = false;
  bool _hasError = false;

  late final StreamController<Job> _streamController;

  @override
  void initState() {
    super.initState();

    _job = widget.job;
    _streamController = StreamController.broadcast();
    _streamController.stream.listen(_onData, onError: _onError);

    _source = widget.source;

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
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: StreamBuilder<Job>(
        stream: _streamController.stream,
        builder: _builder,
      ),
    );
  }

  Widget _builder(BuildContext context, AsyncSnapshot<Job> snapshot) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          _JobDetailHeader(_job),
          const Divider(
            height: 1.0,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 16.0,
          ),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_hasError)
            Center(
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
            ),
          if (_job.description.isNotEmpty)
            HtmlWidget(
              _job.description,
              textStyle: const TextStyle(
                fontSize: 16.0,
              ),
            ),
        ],
      ),
    );
  }

  void _getJob() async {
    try {
      setState(() {
        _loading = true;
      });

      final job = await _source.fetchJob(_job.url);
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
    });
  }

  void _onRetryPressed() {
    _hasError = false;
    _getJob();
  }
}

class _JobDetailHeader extends StatelessWidget {
  const _JobDetailHeader(this.job);

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black87,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0.5,
            blurRadius: 1,
            offset: const Offset(1, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  textDirection: TextDirection.ltr,
                  children: [
                    SizedBox(
                      width: 150.0,
                      height: 150.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Hero(
                          tag: job.url,
                          child: Image.network(
                            job.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      job.companyName,
                      maxLines: 5,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_filled,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: Text(job.posted),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.business,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: Text(job.type),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    GestureDetector(
                      //TODO: Implement on gesture for location
                      onTapUp: (_) {},
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Text(
                              job.location,
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24.0,
          ),
          Column(
            children: [
              Text(
                job.position,
                maxLines: 5,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
