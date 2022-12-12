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
    this.saved = false,
  });

  final String logo;
  final String position;
  final String companyName;
  final String location;
  final String type;
  final String posted;
  final String url;
  final String description;
  final bool saved;

  Map<String, dynamic> toMap() {
    return {
      'logo': logo,
      'position': position,
      'companyName': companyName,
      'location': location,
      'type': type,
      'posted': posted,
      'url': url,
      'description': description,
      'saved': saved,
    };
  }

  factory Job.fromMap(Map<String, dynamic> job) => Job(
        logo: job['logo'] ?? '',
        position: job['position'] ?? '',
        companyName: job['companyName'] ?? '',
        location: job['location'] ?? '',
        type: job['type'] ?? '',
        posted: job['posted'] ?? '',
        url: job['url'] ?? '',
        description: job['description'] ?? '',
        saved: job['saved'] ?? false,
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
        saved: false,
      );
}
