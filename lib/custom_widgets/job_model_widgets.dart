import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart' show Spinner;
import 'package:katswiri/screens/job_detail_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';

class JobsList extends StatefulWidget {
  const JobsList(
    this.jobs, {
    super.key,
    required this.loading,
    required this.error,
    required this.onRetryPressed,
    required this.controller,
    required this.source,
  });

  final List<Job> jobs;
  final bool loading;
  final bool error;
  final void Function() onRetryPressed;
  final ScrollController controller;
  final Source source;

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
    final List<Widget> widgets = _jobs
        .map<Widget>((job) => JobTile(
              job: job,
              source: widget.source,
            ))
        .toList();

    if (widget.loading) {
      widgets.add(
        const Spinner(),
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
                onPressed: widget.onRetryPressed,
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

    return ListView.separated(
      padding: const EdgeInsets.only(top: 8.0),
      controller: widget.controller,
      itemBuilder: (context, index) {
        return widgets[index];
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.grey,
        thickness: .8,
      ),
      itemCount: widgets.length,
    );
  }
}

class JobTile extends StatefulWidget {
  const JobTile({
    super.key,
    required this.job,
    required this.source,
  });

  final Job job;
  final Source source;

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
    return DefaultTextStyle(
      style: const TextStyle(
        color: Colors.white,
      ),
      child: GestureDetector(
        onTapUp: (_) => Navigator.pushNamed(
          context,
          JobDetailScreen.route,
          arguments: {
            'job': _job,
            'source': widget.source,
          },
        ),
        child: JobTileContent(job: _job),
      ),
    );
  }
}

class JobTileContent extends StatelessWidget {
  const JobTileContent({required this.job, super.key});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 2.0,
      ),
      height: 125.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobTileCompanySection(job),
          Expanded(
            child: JobTileDescriptionSection(job),
          ),
        ],
      ),
    );
  }
}

class JobTileImage extends StatelessWidget {
  const JobTileImage({
    super.key,
    required this.job,
    this.size = 75,
  });

  final Job job;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            job.logo,
          ),
        ),
      ),
    );
  }
}

class JobTileCompanySection extends StatelessWidget {
  const JobTileCompanySection(this.job, {super.key});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        JobTileImage(
          job: job,
          size: 46.0,
        ),
        const SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Text(
            job.companyName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
        ),
        JobTileActions(job),
      ],
    );
  }
}

class JobTileDescriptionSection extends StatelessWidget {
  const JobTileDescriptionSection(this.job, {super.key});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              job.position,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                letterSpacing: -.4,
                wordSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    //TODO: Implement location button
                    onPressed: () {},
                    child: Text(
                      job.location,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    job.posted,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JobTileActions extends StatelessWidget {
  const JobTileActions(this.job, {super.key});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
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
          onPressed: () async {},
          icon: const Icon(
            Icons.bookmark_add_outlined,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
