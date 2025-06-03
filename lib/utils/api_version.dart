class ApiVersion {
  final int version;

  ApiVersion({required this.version});

  factory ApiVersion.fromJson(Map<String, dynamic> json) {
    return ApiVersion(
      version: json['version'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'version': version,
    };
  }
}