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

  late final _scrollController = ScrollController();

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: _headerSliverBuilder,
      body: TabBarViewSection(
        tabController: _tabController,
        sources: _sources,
        scrollController: _scrollController,
      ),
    );
  }

  List<Widget> _headerSliverBuilder(BuildContext context, bool isScrolled) {
    return [
      SliverAppBar(
        snap: true,
        floating: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: const [
            Icon(
              Icons.explore_rounded,
              color: Colors.white70,
              size: 28.0,
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Text(
                'Explore',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -.4,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_outlined,
                color: Colors.white70,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
      SliverPadding(
        padding: const EdgeInsets.only(left: 8.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            [
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
              const SizedBox(
                height: 4.0,
              ),
            ],
          ),
        ),
      ),
      SliverPersistentHeader(
        delegate: _SliverTabBarDelegate(
          controller: _tabController,
          sources: _sources,
        ),
      ),
    ];
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate({
    required this.controller,
    required this.sources,
  });

  final TabController controller;
  final List<Source> sources;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }

  TabBar get _tabBar => TabBar(
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
        controller: controller,
        tabs: sources
            .map<Widget>(
              (source) => Tab(
                text: source.title,
              ),
            )
            .toList(),
      );
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
    required this.tabController,
    required this.sources,
    this.scrollController,
    super.key,
  });

  final TabController tabController;
  final List<Source> sources;
  final ScrollController? scrollController;

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
              scrollController: widget.scrollController,
            ),
          )
          .toList(),
    );
  }
}
