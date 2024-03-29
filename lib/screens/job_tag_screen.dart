import 'package:flutter/material.dart';
import 'package:katswiri/components/components.dart' show TabbedSources;

class JobTagScreen extends StatelessWidget {
  const JobTagScreen({
    super.key,
    required this.title,
    required this.filter,
    required this.initialIndex,
  });

  static const route = '/tag';

  final String title;
  final Map<String, String> filter;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          title,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: TabbedSources(
          filter: filter,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}
