class DenominationModel {
  int? id;
  String title;
  String? remark;
  int total;
  String amountText;
  int d2000;
  int d500;
  int d200;
  int d100;
  int d50;
  int d20;
  int d10;
  int d5;
  int d2;
  int d1;
  String createdAt;

  DenominationModel({
    this.id,
    required this.title,
    this.remark,
    required this.total,
    required this.amountText,
    required this.d2000,
    required this.d500,
    required this.d200,
    required this.d100,
    required this.d50,
    required this.d20,
    required this.d10,
    required this.d5,
    required this.d2,
    required this.d1,
    required this.createdAt,
  });

  factory DenominationModel.fromMap(Map<String, dynamic> map) {
    return DenominationModel(
      id: map['id'],
      title: map['title'],
      remark: map['remark'],
      total: map['total'],
      amountText: map['amount_text'],
      d2000: map['d2000'],
      d500: map['d500'],
      d200: map['d200'],
      d100: map['d100'],
      d50: map['d50'],
      d20: map['d20'],
      d10: map['d10'],
      d5: map['d5'],
      d2: map['d2'],
      d1: map['d1'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'remark': remark,
      'total': total,
      'amount_text': amountText,
      'd2000': d2000,
      'd500': d500,
      'd200': d200,
      'd100': d100,
      'd50': d50,
      'd20': d20,
      'd10': d10,
      'd5': d5,
      'd2': d2,
      'd1': d1,
      'created_at': createdAt,
    };
  }
}