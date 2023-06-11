import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';

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
        icon: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
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
      icon: Icon(
        Icons.chevron_left,
        color: Theme.of(context).primaryColor,
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
