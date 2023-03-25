import 'package:katswiri/models/models.dart';

abstract class Source {
  String get title => '';

  String get host => "";

  Future<Job> fetchJob(String url);

  Future<List<Job>> fetchJobs({int page, Map<String, String>? filter});
}
