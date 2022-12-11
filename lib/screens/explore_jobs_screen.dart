import 'package:flutter/material.dart';

class ExploreJobsScreen extends StatefulWidget {
  const ExploreJobsScreen({super.key});

  static const route = '/explore_jobs';

  @override
  State<ExploreJobsScreen> createState() => _ExploreJobsScreenState();
}

class _ExploreJobsScreenState extends State<ExploreJobsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Explore Jobs'),
    );
  }
}
