import 'package:katswiri/managers/managers.dart';

enum SelectedTheme {
  auto('Auto'),
  light('Light'),
  dark('Dark');

  const SelectedTheme(this.name);

  final String name;
}

enum JobView {
  article('Article'),
  browser('Browser');

  const JobView(this.type);

  final String type;
}

class AppSettings {
  static setTheme(SelectedTheme theme) async {
    final prefs = await PrefsManager.instance.prefs;
    await prefs.setString('theme', theme.name);
  }

  static Future<SelectedTheme> getTheme() async {
    final prefs = await PrefsManager.instance.prefs;
    final theme = SelectedTheme.values.firstWhere(
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
          SelectedTheme.auto.name,
        );

    prefs.getString('job_view') ??
        await prefs.setString(
          'job_view',
          JobView.browser.type,
        );
  }
}
