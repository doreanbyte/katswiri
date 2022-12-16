import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';

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

class _JobDetailScreenState extends State<JobDetailScreen>
    with TickerProviderStateMixin {
  late final _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.job.position),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 32.0,
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.blue,
            controller: _tabController,
            tabs: const [
              Tab(text: 'Description'),
              Tab(text: 'Related'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            JobDetailSection(
              job: widget.job,
              source: widget.source,
            ),
            JobListRetriever(
              source: widget.source,
              arguments: {
                'position': widget.job.position,
              },
            ),
          ],
        ),
      ),
    );
  }
}
