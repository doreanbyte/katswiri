import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/source_countries.dart';

abstract class Source {
  String get title => '';

  String get host => '';

  Countries get country => Countries.any;

  Future<Job> fetchJob(String url);

  Future<List<Job>> fetchJobs({
    int page,
    Map<String, String>? filter,
  });
}
