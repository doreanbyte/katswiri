import 'package:flutter/material.dart';
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

class _JobDetailScreenState extends State<JobDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(widget.job.position),
    //     elevation: 0,
    //     backgroundColor: Colors.transparent,
    //     leading: IconButton(
    //       onPressed: () => Navigator.of(context).pop(),
    //       icon: const Icon(
    //         Icons.chevron_left_rounded,
    //         size: 32.0,
    //       ),
    //     ),
    //     bottom: TabBar(
    //       labelColor: Colors.blue,
    //       unselectedLabelColor: Colors.white70,
    //       indicatorColor: Colors.blue,
    //       controller: _tabController,
    //       tabs: const [
    //         Tab(text: 'Description'),
    //         Tab(text: 'Related'),
    //       ],
    //     ),
    //   ),
    //   body: SafeArea(
    //     child: TabBarView(
    //       controller: _tabController,
    //       children: [
    //         JobDetailSection(
    //           job: widget.job,
    //           source: widget.source,
    //         ),
    //         JobListRetriever(
    //           source: widget.source,
    //           arguments: {
    //             'position': widget.job.position,
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      body: SafeArea(
        child: JobDetailContent(
          job: widget.job,
          source: widget.source,
        ),
      ),
    );
  }
}

class JobDetailContent extends StatefulWidget {
  const JobDetailContent({
    super.key,
    required this.job,
    required this.source,
  });

  final Job job;
  final Source source;

  @override
  State<JobDetailContent> createState() => _JobDetailContentState();
}

class _JobDetailContentState extends State<JobDetailContent>
    with TickerProviderStateMixin {
  late final _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isScrolled) => [
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          collapsedHeight: 350,
          expandedHeight: 350,
          flexibleSpace: LeadingSection(
            job: widget.job,
          ),
        ),
      ],
      body: Container(),
    );
  }
}

class LeadingSection extends StatelessWidget {
  const LeadingSection({
    super.key,
    required this.job,
  });

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          opacity: .1,
          fit: BoxFit.cover,
          image: NetworkImage(job.logo),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left_sharp,
              size: 38.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    job.position,
                    style: const TextStyle(
                      fontSize: 38.0,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
