import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart' show TabbedSources;

class JobTagScreen extends StatelessWidget {
  const JobTagScreen({
    super.key,
    required this.title,
    required this.filter,
  });

  static const route = '/tag';

  final String title;
  final Map<String, String> filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(title),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: TabbedSources(
          filter: filter,
        ),
      ),
    );
  }
}
