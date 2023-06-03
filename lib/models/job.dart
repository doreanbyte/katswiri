import 'package:collection/collection.dart';
import 'package:katswiri/utils/utils.dart';

class Job {
  const Job({
    required this.logo,
    required this.position,
    required this.companyName,
    required this.location,
    required this.type,
    required this.posted,
    this.url = '',
    this.description = '',
    required this.tag,
  });

  final String logo;
  final String position;
  final String companyName;
  final String location;
  final String type;
  final String posted;
  final String url;
  final String description;
  final Object? tag;

  Map<String, Object?> toMap() {
    return {
      'logo': logo,
      'position': position,
      'company_name': companyName,
      'location': location,
      'type': type,
      'posted': postedDate(posted).millisecondsSinceEpoch,
      'url': url,
      'description': description,
    };
  }

  factory Job.fromMap(Map<String, Object?> job) => Job(
        logo: job['logo'] as String,
        position: job['position'] as String,
        companyName: job['company_name'] as String,
        location: job['location'] as String,
        type: job['type'] as String,
        posted: getTimeAgo(
          DateTime.fromMillisecondsSinceEpoch(job['posted'] as int),
        ),
        url: job['url'] as String,
        description: job['description'] as String,
        tag: getHeroTag(job['url'] as String),
      );

  factory Job.empty() => const Job(
        logo: '',
        position: '',
        companyName: '',
        location: '',
        type: '',
        posted: '',
        url: '',
        description: '',
        tag: null,
      );

  Job copyWith({
    String? logo,
    String? position,
    String? companyName,
    String? location,
    String? type,
    String? posted,
    String? url,
    String? description,
    Object? tag,
  }) {
    return Job(
      logo: logo ?? this.logo,
      position: position ?? this.position,
      companyName: companyName ?? this.companyName,
      location: location ?? this.location,
      type: type ?? this.type,
      posted: posted ?? this.posted,
      url: url ?? this.url,
      description: description ?? this.description,
      tag: tag ?? this.tag,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Job &&
          runtimeType == other.runtimeType &&
          logo == other.logo &&
          position == other.position &&
          companyName == other.companyName &&
          location == other.location &&
          type == other.type &&
          posted == other.posted &&
          url == other.url &&
          description == other.description &&
          const DeepCollectionEquality().equals(tag, other.tag);

  @override
  int get hashCode =>
      logo.hashCode ^
      position.hashCode ^
      companyName.hashCode ^
      location.hashCode ^
      type.hashCode ^
      posted.hashCode ^
      url.hashCode ^
      description.hashCode ^
      tag.hashCode;
}
