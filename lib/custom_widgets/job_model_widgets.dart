import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImageProvider;
import 'package:flutter/material.dart';
import 'package:katswiri/screens/job_detail_screen.dart';
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
    return DefaultTextStyle(
      style: const TextStyle(
        color: Colors.white,
      ),
      child: GestureDetector(
        onTapUp: (_) => _onTapUp(context),
        child: JobTileComponent(
          job: job,
        ),
      ),
    );
  }

  void _onTapUp(BuildContext context) => Navigator.pushNamed(
        context,
        JobDetailScreen.route,
        arguments: {
          'job': job,
          'source': source,
        },
      );
}

class JobTileComponent extends StatelessWidget {
  const JobTileComponent({
    required this.job,
    super.key,
  });

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
                          child: JobCompanySection(job),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        JobTagsSection(job),
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
          tag: job.url,
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
                style: const TextStyle(
                  color: Colors.green,
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
  const JobTagsSection(this.job, {this.hide = true, super.key});

  final Job job;
  final bool hide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: JobTag(
            icon: const Icon(Icons.location_pin),
            onPressed: () => _onLocationPressed(context),
            label: job.location.isNotEmpty ? job.location : 'Unknown',
          ),
        ),
        Expanded(
          flex: hide ? 2 : 1,
          child: JobTag(
            icon: const Icon(Icons.work),
            onPressed: () => _onTypePressed(context),
            label: job.type.isNotEmpty ? job.type : 'Unknown',
          ),
        ),
      ],
    );
  }

  void _onLocationPressed(BuildContext context) {}

  void _onTypePressed(BuildContext context) {}
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
        style: const TextStyle(
          color: Colors.grey,
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
  late final StreamController<bool> _streamController;

  @override
  void initState() {
    _streamController = StreamController.broadcast();
    _streamController.stream.listen(_onData);
    super.initState();
    Future.delayed(
      Duration.zero,
      () => _getStatus(),
    );
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      builder: _builder,
      stream: _streamController.stream,
    );
  }

  void _onData(bool status) {
    setState(() {});
  }

  Widget _builder(BuildContext context, AsyncSnapshot<bool> snapshot) {
    final isSaved = snapshot.data ?? false;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isSaved
          ? IconButton(
              key: const ValueKey('saved'),
              onPressed: () => _handleUnSave(widget.job),
              icon: const Icon(Icons.bookmark_rounded),
              color: Colors.green,
            )
          : IconButton(
              key: const ValueKey('unsaved'),
              onPressed: () => _handleSave(widget.job),
              icon: const Icon(Icons.bookmark_outline),
              color: Colors.green,
            ),
    );
  }

  //TODO: Implement this method
  void _getStatus() async {
    _streamController.sink.add(false);
  }

  //TODO: Implement this method
  void _handleSave(Job job) async {
    _streamController.sink.add(true);
  }

  //TODO: Implement this method
  void _handleUnSave(Job job) async {
    _streamController.sink.add(false);
  }
}
