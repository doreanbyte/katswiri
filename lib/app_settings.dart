import 'package:katswiri/managers/managers.dart';

enum PreferredTheme {
  auto('Auto'),
  light('Light'),
  dark('Dark');

  const PreferredTheme(this.name);

  final String name;
}

enum PreferredJobView {
  article('Article'),
  browser('Browser');

  const PreferredJobView(this.type);

  final String type;
}

class AppSettings {
  static Future<void> setTheme(PreferredTheme theme) async {
    final prefs = await PrefsManager.instance.prefs;
    await prefs.setString('theme', theme.name);
  }

  static Future<PreferredTheme> getTheme() async {
    final prefs = await PrefsManager.instance.prefs;
    final theme = PreferredTheme.values.firstWhere(
      (theme) => theme.name == prefs.getString('theme'),
    );

    return theme;
  }

  static Future<void> setJobView(PreferredJobView view) async {
    final prefs = await PrefsManager.instance.prefs;
    await prefs.setString('job_view', view.type);
  }

  static Future<PreferredJobView> getJobView() async {
    final prefs = await PrefsManager.instance.prefs;
    final jobView = PreferredJobView.values.firstWhere(
      (element) => element.type == prefs.getString('job_view'),
    );

    return jobView;
  }

  static Future<void> init() async {
    final prefs = await PrefsManager.instance.prefs;
    prefs.getString('theme') ??
        await prefs.setString(
          'theme',
          PreferredTheme.auto.name,
        );

    prefs.getString('job_view') ??
        await prefs.setString(
          'job_view',
          PreferredJobView.browser.type,
        );
  }
}
