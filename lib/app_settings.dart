import 'package:katswiri/managers/managers.dart';

enum Theme {
  auto('Auto'),
  light('Light'),
  dark('Dark');

  const Theme(this.name);

  final String name;
}

enum JobView {
  article('Article'),
  browser('Browser');

  const JobView(this.type);

  final String type;
}

class AppSettings {
  static setTheme(Theme theme) async {
    final prefs = await PrefsManager.instance.prefs;
    await prefs.setString('theme', theme.name);
  }

  static Future<Theme> getTheme() async {
    final prefs = await PrefsManager.instance.prefs;
    final theme = Theme.values.firstWhere(
      (theme) => theme.name == prefs.getString('theme'),
    );

    return theme;
  }

  static setJobView(JobView view) async {
    final prefs = await PrefsManager.instance.prefs;
    await prefs.setString('job_view', view.type);
  }

  static Future<JobView> getJobView() async {
    final prefs = await PrefsManager.instance.prefs;
    final jobView = JobView.values.firstWhere(
      (element) => element.type == prefs.getString('job_view'),
    );

    return jobView;
  }

  static Future<void> init() async {
    final prefs = await PrefsManager.instance.prefs;
    prefs.getString('theme') ??
        await prefs.setString(
          'theme',
          Theme.auto.name,
        );

    prefs.getString('job_view') ??
        await prefs.setString(
          'job_view',
          JobView.browser.type,
        );
  }
}
