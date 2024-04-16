class BatchType {
  final int BTypeID;
  final String BName;
  final String Desc;
  final String BatchID;
  final String StudioID;
  final int View;
  final String stamp;

  BatchType({
    required this.BTypeID,
    required this.BName,
    required this.Desc,
    required this.BatchID,
    required this.StudioID,
    required this.View,
    required this.stamp,
  });

  factory BatchType.fromJson(Map<String, dynamic> json) {
    return BatchType(
      BTypeID: json['BTypeID'],
      BName: json['BName'],
      Desc: json['Desc'],
      BatchID: json['BatchID'],
      StudioID: json['StudioID'],
      View: json['View'],
      stamp: json['stamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BTypeID': BTypeID,
      'BName': BName,
      'Desc': Desc,
      'BatchID': BatchID,
      'StudioID': StudioID,
      'View': View,
      'stamp': stamp,
    };
  }
}
