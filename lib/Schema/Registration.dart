class Registration {
  final String? clientID;
  final String? companyID;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? mobile;
  final String? emergencyContact;
  final String? birthDate;
  final String? address1;
  final String? address2;
  final String? city;
  final String? pinZip;
  final String? stateProvince;
  final String? country;
  final String? height;
  final String? weight;
  final String? occupation;
  final String? companyName;
  final String? spouse;
  final String? spouseOccupation;
  final String? officeAddress;
  final String? eName;
  final String? eAddress;
  final String? eRelationship;
  final String? website;
  final String? emailId;
  final String? batchID;
  final String? userTypeId;
  final String? profileURL;
  final String? password;
  final String? username;
  final String? active;

  Registration({
    required this.clientID,
    required this.companyID,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.mobile,
    required this.emergencyContact,
    required this.birthDate,
    required this.address1,
    required this.address2,
    required this.city,
    required this.pinZip,
    required this.stateProvince,
    required this.country,
    required this.height,
    required this.weight,
    required this.occupation,
    required this.companyName,
    required this.spouse,
    required this.spouseOccupation,
    required this.officeAddress,
    required this.eName,
    required this.eAddress,
    required this.eRelationship,
    required this.website,
    required this.emailId,
    required this.batchID,
    required this.userTypeId,
    required this.profileURL,
    required this.password,
    required this.username,
    required this.active,
  });

  factory Registration.fromJson(Map<String?, dynamic> json) {
    return Registration(
      clientID: json['ClientID'],
      companyID: json['CompanyID'] ?? 0,
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      phone: json['Phone'] ?? 0,
      mobile: json['Mobile'] ?? 0,
      emergencyContact: json['EmergencyContact'] ?? 0,
      birthDate: json['BirthDate'] ?? '',
      address1: json['Address1'] ?? '',
      address2: json['Address2'] ?? '',
      city: json['City'] ?? '',
      pinZip: json['PinZip'] ?? '',
      stateProvince: json['StateProvince'] ?? '',
      country: json['Country'] ?? '',
      height: json['Height'] ?? '',
      weight: json['Weight'] ?? '',
      occupation: json['Occupation'] ?? '',
      companyName: json['CompanyName'] ?? '',
      spouse: json['Spouse'] ?? '',
      spouseOccupation: json['SOccupation'] ?? '',
      officeAddress: json['Office_Address'] ?? '',
      eName: json['EName'] ?? '',
      eAddress: json['EAddress'] ?? '',
      eRelationship: json['ERelationship'] ?? '',
      website: json['Website'] ?? '',
      emailId: json['EmailID'] ?? '',
      batchID: json['BatchID'] ?? 0,
      userTypeId: json['UserTypeID'] ?? 0,
      profileURL: json['profileURL'] ?? '',
      password: json['Password'] ?? '',
      username: json['Username'] ?? '',
      active: json['Active'] ?? 0,
    );
  }
}
