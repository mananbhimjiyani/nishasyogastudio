class FeesCollection {
  String? feeCollectionID;
  String? clientID;
  String? clientFirstName;
  String? clientLastName;
  String? clientMobile;
  String? feeTypeID;
  String? feesName;
  String? cDate;
  String? coupleID;
  String? coupleFirstName;
  String? coupleLastName;
  String? coupleMobile;
  String? promoCode;
  String? form;
  String? formName;
  String? passOnID;
  String? passOnFirstName;
  String? passOnLastName;
  String? passOnMobile;
  String? passOnApprovalID;
  String? passOnApprovalFirstName;
  String? passOnApprovalLastName;
  String? receivedByID;
  String? receivedByFirstName;
  String? receivedByLastName;
  String? receivedByMobile;
  String? membershipChangeID;
  String? membershipChange;
  String? changeDate;
  String? newDate;
  String? approvalID;
  String? approvalFirstName;
  String? approvalLastName;
  String? view;
  String? stamp;

  FeesCollection({
    this.feeCollectionID,
    this.clientID,
    this.clientFirstName,
    this.clientLastName,
    this.clientMobile,
    this.feeTypeID,
    this.feesName,
    this.cDate,
    this.coupleID,
    this.coupleFirstName,
    this.coupleLastName,
    this.coupleMobile,
    this.promoCode,
    this.form,
    this.formName,
    this.passOnID,
    this.passOnFirstName,
    this.passOnLastName,
    this.passOnMobile,
    this.passOnApprovalID,
    this.passOnApprovalFirstName,
    this.passOnApprovalLastName,
    this.receivedByID,
    this.receivedByFirstName,
    this.receivedByLastName,
    this.receivedByMobile,
    this.membershipChangeID,
    this.membershipChange,
    this.changeDate,
    this.newDate,
    this.approvalID,
    this.approvalFirstName,
    this.approvalLastName,
    this.view,
    this.stamp,
  });

  factory FeesCollection.fromJson(Map<String, dynamic> json) {
    return FeesCollection(
      feeCollectionID: json['FeeCollectionID'],
      clientID: json['ClientID'],
      clientFirstName: json['ClientFirstName'],
      clientLastName: json['ClientLastName'],
      clientMobile: json['ClientMobile'],
      feeTypeID: json['FeeTypeID'],
      feesName: json['FeesName'],
      cDate: json['CDate'],
      coupleID: json['CoupleID'],
      coupleFirstName: json['CoupleFirstName'],
      coupleLastName: json['CoupleLastName'],
      coupleMobile: json['CoupleMobile'],
      promoCode: json['PromoCode'],
      form: json['FormID'],
      formName: json['FormName'],
      passOnID: json['PassOnID'],
      passOnFirstName: json['PassOnFirstName'],
      passOnLastName: json['PassOnLastName'],
      passOnMobile: json['PassOnMobile'],
      passOnApprovalID: json['PassOnApprovalID'],
      passOnApprovalFirstName: json['PassOnApprovalFirstName'],
      passOnApprovalLastName: json['PassOnApprovalLastName'],
      receivedByID: json['ReceivedByID'],
      receivedByFirstName: json['ReceivedByFirstName'],
      receivedByLastName: json['ReceivedByLastName'],
      receivedByMobile: json['ReceivedByMobile'],
      membershipChangeID: json['MembershipChangeID'],
      membershipChange: json['MembershipChange'],
      changeDate: json['ChangeDate'],
      newDate: json['NewDate'],
      approvalID: json['ApprovalID'],
      approvalFirstName: json['ApprovalFirstName'],
      approvalLastName: json['ApprovalLastName'],
      view: json['View'],
      stamp: json['stamp'],
    );
  }

  Map<String, dynamic> toJson() {
    var jsonMap = {
      'FeeCollectionID': feeCollectionID,
      'ClientID': clientID,
      'ClientFirstName': clientFirstName,
      'ClientLastName': clientLastName,
      'ClientMobile': clientMobile,
      'FeeTypeID': feeTypeID,
      'FeesName': feesName,
      'CDate': cDate,
      'CoupleID': coupleID,
      'CoupleFirstName': coupleFirstName,
      'CoupleLastName': coupleLastName,
      'CoupleMobile': coupleMobile,
      'PromoCode': promoCode,
      'Form': form,
      'FormName': formName,
      'PassOnID': passOnID,
      'PassOnFirstName': passOnFirstName,
      'PassOnLastName': passOnLastName,
      'PassOnMobile': passOnMobile,
      'PassOnApprovalID': passOnApprovalID,
      'PassOnApprovalFirstName': passOnApprovalFirstName,
      'PassOnApprovalLastName': passOnApprovalLastName,
      'ReceivedByID': receivedByID,
      'ReceivedByFirstName': receivedByFirstName,
      'ReceivedByLastName': receivedByLastName,
      'ReceivedByMobile': receivedByMobile,
      'MembershipChangeID': membershipChangeID,
      'MembershipChange': membershipChange,
      'ChangeDate': changeDate,
      'NewDate': newDate,
      'ApprovalID': approvalID,
      'ApprovalFirstName': approvalFirstName,
      'ApprovalLastName': approvalLastName,
      'View': view,
      'stamp': stamp,
    }..removeWhere((key, value) => value == null);
    // Print key-value pairs where the value is of type DateTime
    jsonMap.forEach((key, value) {
      if (value is DateTime) {
        print('Key: $key, Value: $value');
      }
    });
    return jsonMap;
  }
}
