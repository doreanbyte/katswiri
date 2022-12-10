import 'base_source.dart';
import 'careersmw.dart';
import 'jobsearchmalawi.dart';
import 'onlinejobmw.dart';

List<Source> get sources => [
      CareersMW(),
      OnlineJobMW(),
      JobSearchMW(),
    ];
