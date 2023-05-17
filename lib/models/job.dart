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
  });

  final String logo;
  final String position;
  final String companyName;
  final String location;
  final String type;
  final String posted;
  final String url;
  final String description;

  Map<String, Object?> toMap() {
    return {
      'logo': logo,
      'position': position,
      'company_name': companyName,
      'location': location,
      'type': type,
      'posted': posted,
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
        posted: job['posted'] as String,
        url: job['url'] as String,
        description: job['description'] as String,
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
    );
  }
}
