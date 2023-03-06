import 'package:flutter/material.dart';
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
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          JobLeadSection(widget.job),
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
        height: 210.0,
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
                    height: 8.0,
                  ),
                  Text(
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
                  const SizedBox(
                    height: 8.0,
                  ),
                  Hero(
                    tag: job.url,
                    child: JobTileImage(
                      job: job,
                      size: 40,
                    ),
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
