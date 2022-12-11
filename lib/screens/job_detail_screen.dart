import 'package:flutter/material.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key});

  static const route = '/job_detail';

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Job Detail'),
    );
  }
}
