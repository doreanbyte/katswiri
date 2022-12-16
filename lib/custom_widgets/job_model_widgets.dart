import 'package:flutter/material.dart';
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
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
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

    return ListView.builder(
        controller: widget.controller,
        padding: const EdgeInsets.all(8.0),
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return widgets[index];
        });
  }
}

class JobTile extends StatefulWidget {
  const JobTile({super.key, required this.job, required this.source});

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
    const textColor = Colors.white;

    return GestureDetector(
      onTapUp: (_) => Navigator.pushNamed(
        context,
        JobDetailScreen.route,
        arguments: {
          'job': _job,
          'source': widget.source,
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.only(bottom: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black87,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 1,
              offset: const Offset(1, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70.0,
                  height: 70.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Hero(
                      tag: _job.url,
                      child: Image.network(
                        _job.logo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _job.position,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              _job.companyName,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          //TODO: Add onTapUp gesture detector to location text
                          // to direct user to page showing jobs matching this location
                          Expanded(
                            child: Text(
                              _job.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '${_job.type}  \u2022  ${_job.posted}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      //TODO: Implement saving jobs
                      onTap: () {
                        setState(() {
                          _job = Job(
                            logo: _job.logo,
                            position: _job.position,
                            companyName: _job.companyName,
                            location: _job.location,
                            type: _job.type,
                            posted: _job.posted,
                            url: _job.url,
                            description: _job.description,
                            saved: !_job.saved,
                          );
                        });
                      },
                      child: _job.saved
                          ? const Icon(
                              Icons.bookmark,
                              color: Colors.blue,
                              size: 28.0,
                            )
                          : Icon(
                              Icons.bookmark_outline,
                              color: Colors.grey.shade600,
                              size: 28.0,
                            ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Share.share(
                          _job.url,
                          subject: _job.position,
                        );
                      },
                      icon: const Icon(
                        Icons.share,
                        color: Colors.blue,
                        size: 28.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
