class EtarInspectionModel {
  final String type;
  final String productID;
  final String doer;
  final String comment;
  final String result;
  final String date;
  final String nextDate;
  final String nr;

  EtarInspectionModel(
      {this.nr,
      this.date,
      this.nextDate,
      this.comment,
      this.result,
      this.type,
      this.productID,
      this.doer});

  factory EtarInspectionModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String type = data['type'];
    final String productID = data['productID'];
    final String doer = data['doer'];
    final String comment = data['comment'];
    final String result = data['result'];
    final String date = data['date'];
    final String nextDate = data['nextDate'];
    final String nr = data['nr'];

    return EtarInspectionModel(
      type: type,
      productID: productID,
      doer: doer,
      comment: comment,
      result: result,
      date: date,
      nextDate: nextDate,
      nr: nr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'productID': productID,
      'doer': doer,
      'comment': comment,
      'result': result,
      'date': date,
      'nextDate': nextDate,
      'nr': nr,
    };
  }
}
