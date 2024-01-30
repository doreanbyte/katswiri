import 'package:flutter/material.dart';
import 'package:katswiri/components/components.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) {
      return [Container()];
    }

    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.close,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.chevron_left,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return TabbedSources(
      filter: {'position': query},
      sortJobs: false,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
