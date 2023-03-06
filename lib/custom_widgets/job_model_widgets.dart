import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImageProvider;
import 'package:flutter/material.dart';
import 'package:katswiri/screens/job_detail_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';

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
        child: JobTileComponent(
          job: _job,
        ),
      ),
    );
  }
}

class JobTileComponent extends StatelessWidget {
  const JobTileComponent({required this.job, super.key});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: const Color.fromARGB(96, 64, 64, 64),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 128.0,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: JobTileCompanySection(job),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        JobTileTagsSection(job),
                      ],
                    ),
                  ),
                  JobTileActions(job),
                ],
              ),
            ),
            Align(
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
          ],
        ),
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
          image: CachedNetworkImageProvider(job.logo),
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: job.url,
          child: JobTileImage(
            job: job,
            size: 36.0,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.companyName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                job.position,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.4,
                  wordSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class JobTileTagsSection extends StatelessWidget {
  const JobTileTagsSection(this.job, {super.key});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.location_pin),
            label: Text(
              job.location.isNotEmpty ? job.location : 'Unknown',
              maxLines: 1,
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.work),
            label: Text(job.type.isNotEmpty ? job.type : 'Unknown'),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: IconButton(
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
        ),
        Expanded(
          child: IconButton(
            onPressed: () async {},
            icon: const Icon(
              Icons.bookmark_add_outlined,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
