class Inquiry {
  final String? InquiryID;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String age;
  final String selectedGender;
  final String reason;
  final String practicingYoga;
  final List<String> pain;
  final List<String> illness;
  final String yogaDuration;
  final String yogaLeftDuration;
  final String profession;
  final String reference;
  final String Contacted;
  final DateTime? TimeStamp;
  final String BatchID;
  final String? BatchStartTime;
  final String? BatchEndTime;
  final String BTypeID;
  final String? BName;
  final String StudioID;
  final String? StudioName;

  Inquiry({
    this.InquiryID,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.selectedGender,
    required this.reason,
    required this.practicingYoga,
    required this.pain,
    required this.illness,
    required this.yogaDuration,
    required this.yogaLeftDuration,
    required this.profession,
    required this.reference,
    required this.Contacted,
    required String age,
    required this.BatchID,
    required this.BTypeID,
    required this.StudioID,
    this.TimeStamp,
    this.BatchStartTime,
    this.BatchEndTime,
    this.BName,
    this.StudioName,
  }) : age = age.isNotEmpty ? age : '0';

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'age': age,
      'selectedGender': selectedGender,
      'reason': reason,
      'practicingYoga': practicingYoga,
      'pain': pain.join(", "),
      'illness': illness.join(", "),
      'yogaDuration': practicingYoga == 'Yes' ? yogaDuration : '',
      'yogaLeftDuration': practicingYoga == 'Yes' ? yogaLeftDuration : '',
      'profession': profession,
      'reference': reference,
      'Contacted': Contacted,
      'BTypeID': BTypeID,
      'BatchID': BatchID,
      'StudioID': StudioID,
    };
  }

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      InquiryID: json['InquiryID']?? '',
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      mobileNumber: json['Mobile'] ?? '',
      age: json['Age'] ?? '',
      selectedGender: json['MaleFemale'] == '1' ? 'Male' : 'Female',
      reason: json['Reason'] ?? '',
      practicingYoga: json['Practice'] == '1' ? 'Yes' : 'No',
      pain: json['pain'] != null ? [json['pain']] : [],
      illness: json['Illness'] != null ? [json['Illness']] : [],
      yogaDuration: json['yogaDuration'] ?? '',
      yogaLeftDuration: json['yogaLeftDuration'] ?? '',
      profession: json['Profession'] ?? '',
      reference: json['Reference'] ?? '',
      TimeStamp: DateTime.parse(json['TimeStamp']),
      BatchID: json['BatchID'] ?? '',
      BatchStartTime: json['BatchStartTime'] ?? '',
      BatchEndTime: json['BatchEndTime'] ?? '',
      BTypeID: json['BTypeID'] ?? '',
      BName: json['BName'] ?? '',
      StudioID: json['StudioID'] ?? '',
      StudioName: json['StudioName'] ?? '',
      Contacted: json['Contacted'] ?? '',
    );
  }
}
