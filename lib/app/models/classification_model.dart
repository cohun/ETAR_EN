class Classification {
  final String id;
  final DateTime date;
  final String name;
  final String cerId;
  final DateTime cerDate;
  final String cerName;
  final String classNr;
  final String periodThoroughEx;
  final String periodInspection;

  Classification({
    this.id,
    this.date,
    this.name,
    this.cerId,
    this.cerDate,
    this.cerName,
    this.classNr,
    this.periodThoroughEx,
    this.periodInspection,
  });

  factory Classification.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String id = data['id'];
    final int date = data['date'];
    final String name = data['name'];
    final String cerId = data['cerId'];
    final int cerDate = data['cerDate'];
    final String cerName = data['cerName'];
    final String classNr = data['classNr'];
    final String periodThoroughEx = data['periodThoroughEx'];
    final String periodInspection = data['periodInspection'];

    return Classification(
      id: id,
      date: DateTime.fromMillisecondsSinceEpoch(date),
      name: name,
      cerId: cerId,
      cerDate: DateTime.fromMicrosecondsSinceEpoch(cerDate),
      cerName: cerName,
      classNr: classNr,
      periodThoroughEx: periodThoroughEx,
      periodInspection: periodInspection,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.microsecondsSinceEpoch,
      'name': name,
      'cerId': cerId,
      'cerDate': cerDate.microsecondsSinceEpoch,
      'cerName': cerName,
      'classNr': classNr,
      'periodThoroughEx': periodThoroughEx,
      'periodInspection': periodInspection,
    };
  }
}
