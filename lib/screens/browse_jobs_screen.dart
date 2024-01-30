import 'package:flutter/material.dart';
import 'package:katswiri/components/components.dart';
import 'package:katswiri/sources/sources.dart';

class BrowseJobsScreen extends StatelessWidget {
  const BrowseJobsScreen({
    super.key,
    this.onSourceChange,
  });

  static const route = '/browse';
  final void Function(Source)? onSourceChange;

  @override
  Widget build(BuildContext context) {
    return TabbedSources(
      onSourceChange: onSourceChange,
    );
  }
}
