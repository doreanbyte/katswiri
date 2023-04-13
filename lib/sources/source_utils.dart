import 'base_source.dart';
import 'careersmw.dart';
import 'jobsearchmalawi.dart';
import 'onlinejobmw.dart';
import 'jobinmalawi.dart';

List<Source> getSources() => [
      JobSearchMW(),
      OnlineJobMW(),
      CareersMW(),
      JobInMalawi(),
    ];
