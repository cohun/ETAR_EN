class LogModel {
  final String id;
  final DateTime date;
  final String name;
  final String shift;
  final String entry;
  final bool state;
  final bool repaired;
  final String operatorName;
  final DateTime repairDate;
  final String repairName;

  LogModel({
    this.id,
    this.date,
    this.name,
    this.shift,
    this.entry,
    this.state,
    this.repaired,
    this.operatorName,
    this.repairDate,
    this.repairName,
  });

  factory LogModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String id = data['id'];
    final int date = data['date'];
    final String name = data['name'];
    final String shift = data['shift'];
    final String entry = data['entry'];
    final bool state = data['state'];
    final bool repaired = data['repaired'];
    final String operatorName = data['operatorName'];
    final int repairDate = data['repairDate'];
    final String repairName = data['repairName'];

    return LogModel(
      id: id,
      date: DateTime.fromMicrosecondsSinceEpoch(date),
      name: name,
      shift: shift,
      entry: entry,
      state: state,
      repaired: repaired,
      operatorName: operatorName,
      repairDate: DateTime.fromMicrosecondsSinceEpoch(repairDate),
      repairName: repairName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.microsecondsSinceEpoch,
      'name': name,
      'shift': shift,
      'entry': entry,
      'state': state,
      'repaired': repaired,
      'operatorName': operatorName,
      'repairDate': repairDate.microsecondsSinceEpoch,
      'repairName': repairName,
    };
  }
}
