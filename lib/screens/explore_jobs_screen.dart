import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
import 'package:katswiri/screens/webview_screen.dart';
import 'package:katswiri/sources/sources.dart';

class ExploreJobsScreen extends StatefulWidget {
  const ExploreJobsScreen({super.key});

  static const route = '/explore_jobs';

  @override
  State<ExploreJobsScreen> createState() => _ExploreJobsScreenState();
}

class _ExploreJobsScreenState extends State<ExploreJobsScreen>
    with SingleTickerProviderStateMixin {
  final _sources = getSources();

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: _sources.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExploreLeadSection(
          onPressed: () {
            Navigator.pushNamed(
              context,
              WebViewScreen.route,
              arguments: {
                'url': 'https://${_sources[_tabController.index].host}',
                'title': _sources[_tabController.index].title,
              },
            );
          },
        ),
        TabBarSection(
          controller: _tabController,
          sources: _sources,
        ),
        const SizedBox(
          height: 4.0,
        ),
        Expanded(
          child: TabBarViewSection(
            tabController: _tabController,
            sources: _sources,
          ),
        ),
      ],
    );
  }
}

class ExploreLeadSection extends StatelessWidget {
  const ExploreLeadSection({this.onPressed, super.key});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.4,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_outlined,
                ),
              ),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.public_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TabBarSection extends StatefulWidget {
  const TabBarSection({
    required this.controller,
    required this.sources,
    super.key,
  });

  final TabController controller;
  final List<Source> sources;

  @override
  State<TabBarSection> createState() => _TabBarSectionState();
}

class _TabBarSectionState extends State<TabBarSection> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      isScrollable: true,
      labelStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      indicatorWeight: 3.0,
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.white70,
      controller: widget.controller,
      tabs: widget.sources
          .map<Widget>(
            (source) => Tab(
              text: source.title,
            ),
          )
          .toList(),
    );
  }
}

class TabBarViewSection extends StatefulWidget {
  const TabBarViewSection({
    required this.tabController,
    required this.sources,
    super.key,
  });

  final TabController tabController;
  final List<Source> sources;

  @override
  State<TabBarViewSection> createState() => _TabBarViewSectionState();
}

class _TabBarViewSectionState extends State<TabBarViewSection> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController,
      children: widget.sources
          .map<Widget>(
            (source) => JobListRetriever(
              source: source,
            ),
          )
          .toList(),
    );
  }
}
