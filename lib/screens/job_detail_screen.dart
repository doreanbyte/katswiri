import 'dart:async';

import 'package:flutter/material.dart';
import 'package:katswiri/models/job.dart';
import 'package:katswiri/sources/sources.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key, required this.job, required this.source});

  final Job job;
  final Source source;

  static const route = '/job_detail';

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  Job _job = Job.empty();
  late final Source _source;
  bool _loading = false;

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
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
      stream: _streamController.stream,
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, AsyncSnapshot<Job> snapshot) {
    return Container();
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

  void _onData(Job event) {}

  void _onError(Object error, StackTrace stackTrace) {}
}
