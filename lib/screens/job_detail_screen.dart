import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:katswiri/models/models.dart';
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
  Widget build(BuildContext context) {
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
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LeadingSection(job: widget.job),
      ],
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
    return Card(
      color: const Color.fromARGB(38, 96, 96, 96),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .30,
        child: Stack(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.chevron_left_outlined,
                    color: Colors.blue,
                    size: 28.0,
                  ),
                ),
                const Spacer(),
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
                    size: 28.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.bookmark_add_outlined,
                    color: Colors.blue,
                    size: 28.0,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.public_outlined,
                    color: Colors.blue,
                    size: 28.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
