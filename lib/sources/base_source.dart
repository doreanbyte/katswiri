import 'package:katswiri/models/job.dart';

abstract class BaseSource {
  String get title => '';

  Future<Job> fetchJob(String url);

  Future<List<Job>> fetchJobs({int page});
}
