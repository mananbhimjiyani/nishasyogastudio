class Fop {
  String formId;
  String formName;
  String view;
  String stamp;

  Fop({
    required this.formId,
    required this.formName,
    required this.view,
    required this.stamp,
  });

  factory Fop.fromJson(Map<String, dynamic> json) => Fop(
    formId: json['FormID'],
    formName: json['FormName'] as String,
    view: json['View'],
    stamp: json['stamp'] as String,
  );

  Map<String, dynamic> toJson() => {
    'FormID': formId,
    'FormName': formName,
    'View': view,
    'stamp': stamp,
  };
}
