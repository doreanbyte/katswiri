import 'base_source.dart';
import 'careersmw.dart';
import 'jobsearchmalawi.dart';
import 'onlinejobmw.dart';

List<Source> get _sources => [
      CareersMW(),
      OnlineJobMW(),
      JobSearchMW(),
    ];

List<Source> getSources() => _sources;
