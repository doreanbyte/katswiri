import 'package:katswiri/models/job.dart';

abstract class Source {
  String get title => '';

  Future<Job> fetchJob(String url);

  Future<List<Job>> fetchJobs({int page});
}
