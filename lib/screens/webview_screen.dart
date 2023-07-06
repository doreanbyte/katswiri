import 'package:flutter/material.dart';
import 'package:katswiri/custom_widgets/custom_widgets.dart'
    show ContinuousLinearProgressIndicator;
import 'package:webview_flutter/webview_flutter.dart';

import 'package:katswiri/screens/job_detail_screen.dart';
import 'package:katswiri/sources/sources.dart' show getSources;

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    required this.url,
    required this.title,
    super.key,
  });

  final String url;
  final String title;

  static const route = '/webview';

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  double _progressValue = 0.0;
  bool _loadingArticleView = false;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progressValue = progress / 100;
            });
          },
          onPageStarted: (_) {
            setState(() {
              _progressValue = 0.0;
            });
          },
          onPageFinished: (_) {
            setState(() {
              _progressValue = 1.0;
            });
          },
        ),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final source = getSources().firstWhere(
      (element) => widget.url.contains(element.host),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            Text(
              widget.url,
              style: Theme.of(context).textTheme.labelLarge,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        actions: [
          // Only show change to article view if a job is what is being viewed
          if (!widget.url.endsWith(source.host))
            IconButton(
              tooltip: 'Change to Article View',
              icon: Icon(
                Icons.description,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                try {
                  setState(() {
                    _loadingArticleView = true;
                  });

                  source.fetchJob(widget.url).then(
                        (job) => Navigator.popAndPushNamed(
                          context,
                          JobDetailScreen.route,
                          arguments: {
                            'source': source,
                            'job': job.copyWith(
                              url: widget.url,
                            ),
                          },
                        ),
                      );
                } catch (_) {
                  setState(() {
                    _loadingArticleView = false;
                  });
                }
              },
            ),
        ],
        bottom: _progressValue != 1.0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: LinearProgressIndicator(
                  semanticsLabel: 'Webpage Loading Progress',
                  semanticsValue: '$_progressValue',
                  value: _progressValue,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary),
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (_loadingArticleView)
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: SizedBox(
                  height: 4.0,
                  child: ContinuousLinearProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
