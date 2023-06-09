import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/job_list_retriever.dart';
import 'package:katswiri/sources/sources.dart';

class TabbedSources extends StatefulWidget {
  const TabbedSources({
    this.onSourceChange,
    super.key,
    this.filter,
    this.initialIndex = 0,
  });

  final void Function(Source)? onSourceChange;
  final Map<String, String>? filter;
  final int initialIndex;

  @override
  State<TabbedSources> createState() => _TabbedSourcesState();
}

class _TabbedSourcesState extends State<TabbedSources>
    with SingleTickerProviderStateMixin {
  final _sources = getSources();

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: widget.initialIndex,
      length: _sources.length,
      vsync: this,
    );
    _tabController.addListener(_handleTabSelection);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            filter: widget.filter,
          ),
        ),
      ],
    );
  }

  void _handleTabSelection() {
    final tabIndex = _tabController.index;
    if (widget.onSourceChange != null) {
      widget.onSourceChange!(_sources[tabIndex]);
    }
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
      labelColor: Theme.of(context).tabBarTheme.labelColor,
      unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
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
    this.filter,
    super.key,
  });

  final TabController tabController;
  final List<Source> sources;
  final Map<String, String>? filter;

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
              filter: widget.filter,
            ),
          )
          .toList(),
    );
  }
}
