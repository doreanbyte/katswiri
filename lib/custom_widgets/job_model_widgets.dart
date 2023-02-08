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
      height: MediaQuery.of(context).size.height * .13,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobTileCompanySection(job: job),
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
          fit: BoxFit.fill,
          image: NetworkImage(
            job.logo,
          ),
        ),
      ),
    );
  }
}

class JobTileCompanySection extends StatelessWidget {
  const JobTileCompanySection({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        JobTileImage(
          job: job,
          size: 34.0,
        ),
        const SizedBox(
          width: 8.0,
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
      ],
    );
  }
}

class JobTileActions extends StatelessWidget {
  const JobTileActions(this.job, {super.key});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          //TODO: Implement onPressed
          onPressed: () {},
          icon: const Icon(
            Icons.location_city,
          ),
          label: Text(
            job.location,
            maxLines: 1,
          ),
        ),
        IconButton(
          onPressed: () async {
            await Share.share(
              job.url,
              subject: job.position,
            );
          },
          icon: const Icon(
            Icons.share,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
