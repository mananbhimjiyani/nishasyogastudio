class Studio {
  final int StudioID;
  final String StudioName;
  final String Location;

  Studio({
    required this.StudioID,
    required this.StudioName,
    required this.Location,
  });

  factory Studio.fromJson(Map<String, dynamic> json) {
    return Studio(
      StudioID: json['StudioID'] ?? 0,
      StudioName: json['StudioName'] ?? '',
      Location: json['Location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StudioID': StudioID,
      'StudioName': StudioName,
      'Location': Location,
    };
  }
}
