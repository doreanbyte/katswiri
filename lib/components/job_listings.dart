import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:katswiri/bloc/bloc.dart';
import 'package:katswiri/components/components.dart';
import 'package:katswiri/sources/sources.dart';

class JobListings extends StatefulWidget {
  const JobListings({
    super.key,
    required this.source,
    this.filter,
    this.primary,
  });

  final Source source;
  final Map<String, String>? filter;
  final bool? primary;

  @override
  State<JobListings> createState() => _JobListingsState();
}

class _JobListingsState extends State<JobListings>
    with AutomaticKeepAliveClientMixin<JobListings> {
  late final Source _source;
  bool _showScrollTop = false;
  late final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _source = widget.source;
    _scrollController.addListener(_onScrollEnd);
    _scrollController.addListener(_onShowToTop);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEnd);
    _scrollController.removeListener(_onShowToTop);

    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        BlocBuilder<JobsListBloc, JobsListState>(
          builder: _builder,
        ),
        Positioned(
          right: 16.0,
          bottom: 16.0,
          child: _ScrollToTop(
            onPressed: _scrollToTop,
            showScrollTop: _showScrollTop,
          ),
        ),
      ],
    );
  }

  Widget _builder(BuildContext context, JobsListState state) {
    final Widget child;
    final jobs = switch (state) {
      JobsListLoaded(:final jobs) => jobs,
      JobsListLoading(:final jobs) => jobs,
      JobsListError(:final jobs) => jobs
    };

    if (state is JobsListLoading && jobs.isEmpty) {
      child = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final List<Widget> widgetList = jobs
          .map<Widget>((job) => JobTile(
                job: job,
                source: _source,
              ))
          .toList();

      if (state is JobsListLoading) {
        widgetList.add(
          const Spinner(),
        );
      }

      if (state case JobsListError(:final error)) {
        widgetList.add(
          ErrorButton(
            errorMessage: error,
            onRetryPressed: _onRetryPressed,
          ),
        );
      }

      final errorMessage = switch (state) {
        JobsListError(error: final error) => error,
        _ => ''
      };

      if (jobs.isEmpty && state is! JobsListLoading && errorMessage.isEmpty) {
        widgetList.add(
          Center(
            child: Column(
              children: [
                const Text('No Results Found'),
                RetryButton(
                  onRetryPressed: _onRetryPressed,
                ),
              ],
            ),
          ),
        );
      }

      child = ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 4.0),
        primary: widget.primary,
        itemBuilder: (context, index) => widgetList[index],
        itemCount: widgetList.length,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: child,
    );
  }

  void _onScrollEnd() {
    final offset = _scrollController.offset;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final bloc = context.read<JobsListBloc>();
    final state = bloc.state;

    final loading = switch (state) {
      JobsListLoading() => true,
      _ => false,
    };

    final hasError = switch (state) {
      JobsListError() => true,
      _ => false,
    };

    // If offset is equal to or greater than max scroll extent and the _loading
    // field is not set to true and the _error field is not set to true indicating
    // an error occured. Call _getJobs to fetch extra data
    if (offset >= maxScrollExtent && !loading && !hasError) {
      bloc.add(FetchJobs(filter: widget.filter));
    }
  }

  void _onShowToTop() {
    if (_scrollController.offset >= 100 && !_showScrollTop) {
      setState(() {
        _showScrollTop = true;
      });
    } else if (_scrollController.offset < 100 && _showScrollTop) {
      setState(() {
        _showScrollTop = false;
      });
    }
  }

  void _onRetryPressed() => context.read<JobsListBloc>().add(
        FetchJobs(filter: widget.filter),
      );

  Future<void> _onRefresh() async =>
      context.read<JobsListBloc>().add(RefreshJobs(filter: widget.filter));

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

class _ScrollToTop extends StatefulWidget {
  const _ScrollToTop({
    required this.onPressed,
    required this.showScrollTop,
  });

  final void Function() onPressed;
  final bool showScrollTop;

  @override
  State<_ScrollToTop> createState() => __ScrollToTopState();
}

class __ScrollToTopState extends State<_ScrollToTop> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.showScrollTop ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticIn,
      child: Visibility(
        visible: widget.showScrollTop,
        child: FloatingActionButton(
          onPressed: widget.onPressed,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }
}
