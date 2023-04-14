import 'package:flutter/material.dart';
import 'package:katswiri/screens/explore_jobs_screen.dart';
import 'package:katswiri/screens/saved_jobs_screen.dart';
import 'package:katswiri/screens/history_screen.dart';
import 'package:katswiri/screens/search_screen.dart';
import 'package:katswiri/screens/webview_screen.dart';
import 'package:katswiri/sources/sources.dart';

enum Page {
  explore,
  history,
  saved,
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
            ExploreJobsScreen(
              onSourceChange: (source) {
                _setSource(source);
              },
            ),
            const HistoryScreen(),
            const SavedJobsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF000000),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
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
      case Page.explore:
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Explore',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              letterSpacing: -.4,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(
                Icons.search_outlined,
                color: Colors.green,
              ),
            ),
            IconButton(
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
              icon: const Icon(
                Icons.public_outlined,
                color: Colors.green,
              ),
            ),
          ],
        );
      case Page.history:
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'History',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              letterSpacing: -.4,
            ),
          ),
        );
      case Page.saved:
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Saved',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              letterSpacing: -.4,
            ),
          ),
        );
    }
  }
}
