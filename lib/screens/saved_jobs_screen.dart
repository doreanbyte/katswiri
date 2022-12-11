import 'package:flutter/material.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  static const route = '/saved_jobs';

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Saved Jobs'),
    );
  }
}
