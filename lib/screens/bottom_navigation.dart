import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/bloc/bloc.dart';
import 'package:katswiri/screens/browse_jobs_screen.dart';
import 'package:katswiri/screens/more_screen.dart';
import 'package:katswiri/screens/saved_jobs_screen.dart';
import 'package:katswiri/screens/history_screen.dart';
import 'package:katswiri/screens/search_screen.dart';
import 'package:katswiri/screens/webview_screen.dart';
import 'package:katswiri/sources/sources.dart';

enum Page {
  listings('Listings'),
  history('History'),
  saved('Saved'),
  more('More');

  const Page(this.title);

  final String title;
}

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  static const route = '/';

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  // The current index of the page to display
  int _selectedIndex = 0;
  // The source that is currently being viewed relative to the explore page
  Source _source = getSources().first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(
        context,
        Page.values[_selectedIndex],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            BrowseJobsScreen(
              onSourceChange: (source) {
                _setSource(source);
              },
            ),
            const HistoryScreen(),
            const SavedJobsScreen(),
            const MoreScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore_outlined),
            activeIcon: const Icon(Icons.list_rounded),
            label: Page.listings.title,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history_outlined),
            activeIcon: const Icon(Icons.history_rounded),
            label: Page.history.title,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark_outline),
            activeIcon: const Icon(Icons.bookmark_rounded),
            label: Page.saved.title,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            activeIcon: const Icon(Icons.more_horiz_rounded),
            label: Page.more.title,
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  void _setSource(Source source) {
    setState(() {
      _source = source;
    });
  }

  AppBar _buildAppBar(BuildContext context, Page page) {
    switch (page) {
      case Page.listings:
        return AppBar(
          title: Text(
            Page.listings.title,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              letterSpacing: -.4,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Search for Job',
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: Icon(
                Icons.search_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            IconButton(
              tooltip: 'Open in Browser',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  WebViewScreen.route,
                  arguments: {
                    'url': 'https://${_source.host}',
                    'title': _source.title,
                  },
                );
              },
              icon: Icon(
                Icons.public_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        );
      case Page.history:
        return AppBar(
          title: Text(
            Page.history.title,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              letterSpacing: -.4,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => _showClearHistory(context),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        );
      case Page.saved:
        return AppBar(
          title: Text(
            Page.saved.title,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              letterSpacing: -.4,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => _showClearSavedJobs(context),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        );
      case Page.more:
        return AppBar(
          title: const Text(
            'More',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
              letterSpacing: -.4,
            ),
          ),
        );
    }
  }

  Future<void> _showClearHistory(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Clear History',
          ),
          content: const Text('Are you sure you want to clear your history?'),
          actions: [
            TextButton(
              child: Text(
                'No',
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                context.read<HistoryBloc>().add(const ClearHistory());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showClearSavedJobs(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Clear Saved Jobs',
          ),
          content:
              const Text('Are you sure you want to clear your saved jobs?'),
          actions: [
            TextButton(
              child: Text(
                'No',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                context.read<SavedJobsBloc>().add(const DeleteSavedJobs());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
