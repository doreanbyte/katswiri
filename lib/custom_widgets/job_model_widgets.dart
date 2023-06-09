import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImageProvider;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/bloc/bloc.dart';
import 'package:katswiri/screens/job_detail_screen.dart';
import 'package:katswiri/screens/job_tag_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/sources.dart';

class JobTile extends StatelessWidget {
  const JobTile({
    required this.job,
    required this.source,
    super.key,
  });

  final Job job;
  final Source source;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (_) => _onTapUp(context),
      child: JobTileComponent(
        job: job,
        sourceIndex:
            getSources().indexWhere((element) => element.title == source.title),
      ),
    );
  }

  void _onTapUp(BuildContext context) {
    context.read<HistoryBloc>().add(AddToHistory(job));
    Navigator.pushNamed(
      context,
      JobDetailScreen.route,
      arguments: {
        'job': job,
        'source': source,
      },
    );
  }
}

class JobTileComponent extends StatelessWidget {
  const JobTileComponent({
    required this.job,
    required this.sourceIndex,
    super.key,
  });

  final Job job;
  final int sourceIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Theme.of(context).cardTheme.color,
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
                          child: JobCompanySection(job),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        JobTagsSection(
                          job,
                          initialIndex: sourceIndex,
                        ),
                      ],
                    ),
                  ),
                  JobActions(job),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                job.posted,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class JobThumbnailImage extends StatelessWidget {
  const JobThumbnailImage({
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

class JobCompanySection extends StatelessWidget {
  const JobCompanySection(this.job, {super.key});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: job.tag as Object,
          child: JobThumbnailImage(
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
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
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

class JobTagsSection extends StatelessWidget {
  const JobTagsSection(
    this.job, {
    required this.initialIndex,
    this.hide = true,
    super.key,
  });

  final Job job;
  final bool hide;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: JobTag(
            icon: const Icon(Icons.location_pin),
            onPressed: () {
              Navigator.pushNamed(
                context,
                JobTagScreen.route,
                arguments: {
                  'title': job.location,
                  'filter': {
                    'location': job.location,
                  },
                  'initialIndex': initialIndex,
                },
              );
            },
            label: job.location.isNotEmpty ? job.location : 'Unknown',
          ),
        ),
        Expanded(
          flex: hide ? 2 : 1,
          child: JobTag(
            icon: const Icon(Icons.work),
            onPressed: () {
              Navigator.pushNamed(
                context,
                JobTagScreen.route,
                arguments: {
                  'title': job.type,
                  'filter': {
                    'type': job.type,
                  },
                  'initialIndex': initialIndex,
                },
              );
            },
            label: job.type.isNotEmpty ? job.type : 'Unknown',
          ),
        ),
      ],
    );
  }
}

class JobTag extends StatelessWidget {
  const JobTag({
    required this.icon,
    required this.onPressed,
    required this.label,
    super.key,
  });

  final Icon icon;
  final void Function() onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
        ),
      ),
    );
  }
}

class JobActions extends StatelessWidget {
  const JobActions(this.job, {super.key});

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
            ),
          ),
        ),
        Expanded(
          child: SaveJobButton(
            job: job,
          ),
        ),
      ],
    );
  }
}

class SaveJobButton extends StatefulWidget {
  const SaveJobButton({
    required this.job,
    super.key,
  });

  final Job job;

  @override
  SaveJobButtonState createState() => SaveJobButtonState();
}

class SaveJobButtonState extends State<SaveJobButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveJobBloc, SaveJobState>(
      listener: (context, jobSaveState) {},
      builder: (context, jobSaveState) => switch (jobSaveState) {
        SavedJobsList(jobs: final jobs) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: switch (
                jobs.firstWhereOrNull((job) => job.url == widget.job.url)) {
              Job() => IconButton(
                  key: const ValueKey('saved'),
                  onPressed: () => _handleUnSave(context),
                  icon: const Icon(Icons.bookmark_rounded),
                  color: Theme.of(context).primaryColor,
                ),
              _ => IconButton(
                  key: const ValueKey('unsaved'),
                  onPressed: () => _handleSave(context),
                  icon: const Icon(Icons.bookmark_outline),
                  color: Theme.of(context).iconTheme.color,
                ),
            },
          ),
        _ => IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.bookmark_outline),
            onPressed: null,
          )
      },
    );
  }

  void _handleSave(BuildContext context) {
    context.read<SaveJobBloc>().add(SaveJobEvent(widget.job));
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      context.read<SavedJobsBloc>().add(const FetchSavedJobs());
    });
  }

  void _handleUnSave(BuildContext context) {
    context.read<SaveJobBloc>().add(UnsaveJobEvent(widget.job));
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      context.read<SavedJobsBloc>().add(const FetchSavedJobs());
    });
  }
}
