class User {
  final int clientId;
  final int? companyId;
  final String firstName;
  final String lastName;
  final int? phone;
  final int? mobile;
  final int? emergencyContact;
  final String birthDate;
  final String photo;
  final String address1;
  final String address2;
  final String city;
  final String pinZip;
  final String stateProvince;
  final String country;
  final String website;
  final String emailId;
  final int? batchId;
  final int? userTypeId;
  final String profileUrl;
  final String password;
  final String username;
  final int? active;
  final String dateStamp;
  final String timeStamp;

  User({
    required this.clientId,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.mobile,
    required this.emergencyContact,
    required this.birthDate,
    required this.photo,
    required this.address1,
    required this.address2,
    required this.city,
    required this.pinZip,
    required this.stateProvince,
    required this.country,
    required this.website,
    required this.emailId,
    required this.batchId,
    required this.userTypeId,
    required this.profileUrl,
    required this.password,
    required this.username,
    required this.active,
    required this.dateStamp,
    required this.timeStamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'ClientID': clientId,
      'CompanyID': companyId,
      'FirstName': firstName,
      'LastName': lastName,
      'Phone': phone,
      'Mobile': mobile,
      'EmergencyContact': emergencyContact,
      'BirthDate': birthDate,
      'Photo': photo,
      'Address1': address1,
      'Address2': address2,
      'City': city,
      'PinZip': pinZip,
      'StateProvince': stateProvince,
      'Country': country,
      'Website': website,
      'EmailID': emailId,
      'BatchID': batchId,
      'UserTypeID': userTypeId,
      'profileURL': profileUrl,
      'Password': password,
      'Username': username,
      'Active': active,
      'DateStamp': dateStamp,
      'TimeStamp': timeStamp,
    };
  }


  void printUser() {
    print('ClientID: $clientId');
    print('CompanyID: $companyId');
    print('FirstName: $firstName');
    print('LastName: $lastName');
    print('Phone: $phone');
    print('Mobile: $mobile');
    print('EmergencyContact: $emergencyContact');
    print('BirthDate: $birthDate');
    print('Photo: $photo');
    print('Address1: $address1');
    print('Address2: $address2');
    print('City: $city');
    print('PinZip: $pinZip');
    print('StateProvince: $stateProvince');
    print('Country: $country');
    print('Website: $website');
    print('EmailID: $emailId');
    print('BatchID: $batchId');
    print('UserTypeID: $userTypeId');
    print('profileURL: $profileUrl');
    print('Password: $password');
    print('Username: $username');
    print('Active: $active');
    print('DateStamp: $dateStamp');
    print('TimeStamp: $timeStamp');
  }

  factory User.fromJson(Map<String, dynamic> json) {
    // Check if the JSON contains ClientID as a String
    if (json['ClientID'] is String) {
      return User(
        clientId: int.parse(json['ClientID']), // Parse ClientID as int
        companyId: json['CompanyID'] != null ? int.parse(json['CompanyID']) : null,
        firstName: json['FirstName'] ?? '',
        lastName: json['LastName'] ?? '',
        phone: json['Phone'] != null ? int.parse(json['Phone']) : null,
        mobile: json['Mobile'] != null ? int.parse(json['Mobile']) : null,
        emergencyContact: json['EmergencyContact'] != null ? int.parse(json['EmergencyContact']) : null,
        birthDate: json['BirthDate'] ?? '',
        photo: json['Photo'] ?? '',
        address1: json['Address1'] ?? '',
        address2: json['Address2'] ?? '',
        city: json['City'] ?? '',
        pinZip: json['PinZip'] ?? '',
        stateProvince: json['StateProvince'] ?? '',
        country: json['Country'] ?? '',
        website: json['Website'] ?? '',
        emailId: json['EmailID'] ?? '',
        batchId: json['BatchID'] != null ? int.parse(json['BatchID']) : null,
        userTypeId: json['UserTypeID'] != null ? int.parse(json['UserTypeID']) : null,
        profileUrl: json['profileURL'] ?? '',
        password: json['Password'] ?? '',
        username: json['Username'] ?? '',
        active: json['Active'] != null ? int.parse(json['Active']) : null,
        dateStamp: json['DateStamp'] ?? '',
        timeStamp: json['TimeStamp'] ?? '',
      );
    } else {
      // If ClientID is already an int, proceed with the original parsing
      return User(
        clientId: json['ClientID'], // Assume it's already an int
        companyId: json['CompanyID'],
        firstName: json['FirstName'] ?? '',
        lastName: json['LastName'] ?? '',
        phone: json['Phone'],
        mobile: json['Mobile'],
        emergencyContact: json['EmergencyContact'],
        birthDate: json['BirthDate'] ?? '',
        photo: json['Photo'] ?? '',
        address1: json['Address1'] ?? '',
        address2: json['Address2'] ?? '',
        city: json['City'] ?? '',
        pinZip: json['PinZip'] ?? '',
        stateProvince: json['StateProvince'] ?? '',
        country: json['Country'] ?? '',
        website: json['Website'] ?? '',
        emailId: json['EmailID'] ?? '',
        batchId: json['BatchID'],
        userTypeId: json['UserTypeID'],
        profileUrl: json['profileURL'] ?? '',
        password: json['Password'] ?? '',
        username: json['Username'] ?? '',
        active: json['Active'],
        dateStamp: json['DateStamp'] ?? '',
        timeStamp: json['TimeStamp'] ?? '',
      );
    }
  }

}
