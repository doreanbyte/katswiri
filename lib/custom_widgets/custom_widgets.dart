import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:katswiri/app_theme.dart';

export 'job_model_widgets.dart';
export 'job_list_retriever.dart';
export 'tabbed_sources.dart';
export 'button_widgets.dart';

class Spinner extends StatelessWidget {
  const Spinner({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

class AppThemeBuilder extends StatelessWidget {
  const AppThemeBuilder({super.key, required this.builder});

  final Widget Function(
    BuildContext context,
    ({
      ThemeData lightTheme,
      ThemeData darkTheme,
    }) appTheme,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) => builder(
        context,
        fillWith(
          light: light,
          dark: dark,
        ),
      ),
    );
  }
}

class ContinuousLinearProgressIndicator extends StatefulWidget {
  const ContinuousLinearProgressIndicator({super.key});

  @override
  State<ContinuousLinearProgressIndicator> createState() =>
      _ContinuousLinearProgressIndicatorState();
}

class _ContinuousLinearProgressIndicatorState
    extends State<ContinuousLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _animationController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      semanticsLabel: 'Article Loading Progress',
      value: _animationController.value,
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
