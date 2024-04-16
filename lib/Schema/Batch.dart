class Batch {
  final int BatchID;
  final int CompanyID;
  final String BatchStartTime;
  final String BatchEndTime;
  final String workingDays;
  final int view;
  final String timeStamp;

  Batch({
    required this.BatchID,
    required this.CompanyID,
    required this.BatchStartTime,
    required this.BatchEndTime,
    required this.workingDays,
    required this.view,
    required this.timeStamp,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      BatchID: json['BatchID'],
      CompanyID: json['CompanyID'],
      BatchStartTime: json['BatchStartTime'],
      BatchEndTime: json['BatchEndTime'],
      workingDays: json['WorkingDays'],
      view: json['View'],
      timeStamp: json['TimeStamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BatchID': BatchID,
      'CompanyID': CompanyID,
      'BatchStartTime': BatchStartTime,
      'BatchEndTime': BatchEndTime,
      'WorkingDays': workingDays,
      'View': view,
      'TimeStamp': timeStamp,
    };
  }
}