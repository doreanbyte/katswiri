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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: const Color.fromARGB(58, 64, 64, 64),
      child: SizedBox(
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
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Hero(
            tag: job.url,
            child: JobTileImage(
              job: job,
              size: 36.0,
            ),
          ),
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
              fontWeight: FontWeight.w600,
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
                        fontWeight: FontWeight.w700,
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
                      fontWeight: FontWeight.w700,
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
