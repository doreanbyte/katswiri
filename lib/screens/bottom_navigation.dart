import 'package:flutter/material.dart';
import 'package:katswiri/screens/explore_jobs_screen.dart';
import 'package:katswiri/screens/saved_jobs_screen.dart';
import 'package:katswiri/screens/history_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  static const route = '/';

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  /// The current index of the page to display
  int _selectedIndex = 0;

  final navViews = <Widget>[
    const ExploreJobsScreen(),
    const HistoryScreen(),
    const SavedJobsScreen(),
  ];

  final navBarItems = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.explore_outlined),
      activeIcon: Icon(Icons.explore_rounded),
      label: 'Explore',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.history_outlined),
      activeIcon: Icon(Icons.history_rounded),
      label: 'History',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bookmark_outline),
      activeIcon: Icon(Icons.bookmark_rounded),
      label: 'Saved',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    assert(navViews.length == navBarItems.length);

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: navViews,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF000000),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        items: navBarItems,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
