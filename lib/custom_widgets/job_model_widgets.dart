import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katswiri/models/job.dart';
import 'package:katswiri/sources/sources.dart';

class JobListRetriever extends StatefulWidget {
  const JobListRetriever({super.key, required this.source});

  final Source source;

  @override
  State<JobListRetriever> createState() => _JobListRetrieverState();
}

class _JobListRetrieverState extends State<JobListRetriever> {
  late final Source _source;
  final List<Job> _jobs = [];

  int _page = 1;
  bool _loading = false;
  bool _hasError = false;

  late final StreamController<List<Job>> _streamController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _source = widget.source;
    _streamController = StreamController.broadcast();

    _streamController.stream.listen(_onData, onError: _onError);

    _scrollController = ScrollController()..addListener(_onScrollEnd);

    _getJobs();
  }

  @override
  void dispose() {
    _streamController.close();
    _scrollController.removeListener(_onScrollEnd);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Job>>(
      stream: _streamController.stream,
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
    return JobsList(
      _jobs,
      loading: _loading,
      error: _hasError,
      onRefreshPressed: _onRefreshPressed,
      controller: _scrollController,
    );
  }

  void _getJobs() async {
    try {
      setState(() {
        _loading = true;
      });
      final jobs = await _source.fetchJobs(page: _page);
      _streamController.sink.add(jobs);
    } catch (e) {
      _streamController.addError(e);
    }
  }

  void _onScrollEnd() {
    final offset = _scrollController.offset;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;

    // If offset is equal to or greater than max scroll extent and the _loading
    // field is not set to true and the _error field is not set to true indicating
    // an error occured. Call _getJobs to fetch extra data
    if (offset >= maxScrollExtent && !_loading && !_hasError) {
      _getJobs();
    }
  }

  void _onData(List<Job> jobs) {
    _jobs.addAll(jobs);

    setState(() {
      _page++;
      _loading = false;
    });
  }

  void _onError(Object object, StackTrace stackTrace) {
    _loading = false;
    setState(() {
      _hasError = true;
    });
  }

  void _onRefreshPressed() {
    _hasError = false;
    _getJobs();
  }
}

class JobsList extends StatefulWidget {
  const JobsList(
    this.jobs, {
    super.key,
    required this.loading,
    required this.error,
    required this.onRefreshPressed,
    required this.controller,
  });

  final List<Job> jobs;
  final bool loading;
  final bool error;
  final void Function() onRefreshPressed;
  final ScrollController controller;

  @override
  State<JobsList> createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  late final List<Job> _jobs;

  @override
  void initState() {
    super.initState();
    _jobs = widget.jobs;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets =
        _jobs.map<Widget>((job) => JobTile(job: job)).toList();

    if (widget.loading) {
      widgets.add(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.error) {
      widgets.add(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: widget.onRefreshPressed,
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
      );
    }

    return ListView.builder(
        controller: widget.controller,
        padding: const EdgeInsets.all(8.0),
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return widgets[index];
        });
  }
}

class JobTile extends StatefulWidget {
  const JobTile({super.key, required this.job});

  final Job job;

  @override
  State<JobTile> createState() => _JobTileState();
}

class _JobTileState extends State<JobTile> {
  Job _job = Job.empty();

  @override
  void initState() {
    super.initState();

    _job = widget.job;
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Colors.white;

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 24.0),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _job = Job(
                      logo: _job.logo,
                      position: _job.position,
                      companyName: _job.companyName,
                      location: _job.location,
                      type: _job.type,
                      posted: _job.posted,
                      url: _job.url,
                      description: _job.description,
                      saved: !_job.saved,
                    );
                  });
                },
                child: _job.saved
                    ? const Icon(
                        Icons.bookmark,
                        color: Colors.blue,
                        size: 28.0,
                      )
                    : Icon(
                        Icons.bookmark_outline,
                        color: Colors.grey.shade600,
                        size: 28.0,
                      ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share,
                  color: Colors.blue,
                  size: 28.0,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Center(
            child: Text(
              _job.companyName,
              maxLines: 2,
              style: const TextStyle(
                color: textColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 85.0,
                      height: 85.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.0),
                        child: Image.network(
                          _job.logo,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _job.position,
                            style: const TextStyle(
                              color: textColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          Text(
                            _job.location,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 28.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _job.type,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        _job.posted,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
