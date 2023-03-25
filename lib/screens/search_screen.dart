import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/sources/sources.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen(
    this.title, {
    super.key,
    required this.source,
    required this.arguments,
  });

  final String title;
  final Source source;
  final Map<String, String> arguments;

  static const route = '/general_search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
      ),
      body: JobListRetriever(
        source: source,
        filter: arguments,
      ),
    );
  }
}
