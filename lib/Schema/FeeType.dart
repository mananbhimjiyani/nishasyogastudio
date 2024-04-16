class FeeType {
  String feeTypeId;
  String feesName;
  String amount;
  String studioId;
  String batchId;
  String batchTypeId;
  String session;
  String days;
  String remarks;
  String view;
  String stamp;

  FeeType({
    required this.feeTypeId,
    required this.feesName,
    required this.amount,
    required this.studioId,
    required this.batchId,
    required this.batchTypeId,
    required this.session,
    required this.days,
    required this.remarks,
    required this.view,
    required this.stamp,
  });

  factory FeeType.fromJson(Map<String, dynamic> json) {
    return FeeType(
      feeTypeId: json['FeeTypeID'],
      feesName: json['FeesName'],
      amount: json['Amount'],
      studioId: json['StudioID'],
      batchId: json['BatchID'],
      batchTypeId: json['BatchTypID'],
      session: json['Session'],
      days: json['days'],
      remarks: json['Remarks'],
      view: json['view'],
      stamp: json['stamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FeeTypeID': feeTypeId,
      'FeesName': feesName,
      'Amount': amount,
      'StudioID': studioId,
      'BatchID': batchId,
      'BatchTypID': batchTypeId,
      'Session': session,
      'days': days,
      'Remarks': remarks,
      'view': view, // Convert boolean to string
      'stamp': stamp.toString(),
    };
  }
}
