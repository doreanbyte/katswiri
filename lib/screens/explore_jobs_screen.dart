import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart';
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

  late final _tabController = TabController(
    length: _sources.length,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExploreLeadSection(),
        TabBarSection(
          controller: _tabController,
          sources: _sources,
        ),
        const SizedBox(
          height: 12.0,
        ),
        Expanded(
          child: TabBarViewSection(
            controller: _tabController,
            sources: _sources,
          ),
        ),
      ],
    );
  }
}

class ExploreLeadSection extends StatelessWidget {
  const ExploreLeadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.explore_rounded,
                color: Colors.white70,
                size: 28.0,
              ),
              const SizedBox(
                width: 8.0,
              ),
              const Expanded(
                child: Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -.4,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.white70,
                  size: 28.0,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          const Text(
            'Browse and Discover Jobs from Multiple Sources',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: TabBar(
        isScrollable: true,
        labelStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
        indicatorWeight: 3.0,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.white70,
        indicatorColor: Colors.blue,
        controller: widget.controller,
        tabs: widget.sources
            .map<Widget>(
              (source) => Tab(
                text: source.title,
              ),
            )
            .toList(),
      ),
    );
  }
}

class TabBarViewSection extends StatefulWidget {
  const TabBarViewSection({
    required this.controller,
    required this.sources,
    super.key,
  });

  final TabController controller;
  final List<Source> sources;

  @override
  State<TabBarViewSection> createState() => _TabBarViewSectionState();
}

class _TabBarViewSectionState extends State<TabBarViewSection> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.controller,
      children: widget.sources
          .map<Widget>((source) => JobListRetriever(source: source))
          .toList(),
    );
  }
}
