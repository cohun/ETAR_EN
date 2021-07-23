class OperationModel {
  final String id;
  final DateTime date;
  final String name;
  final String cerId;
  final DateTime cerDate;
  final String cerName;
  final String cerAuthority;
  final String startName;
  final String startAuthority;
  final DateTime startDate;
  final bool state;
  final String cause;

  OperationModel(
       {
    this.id,
    this.date,
    this.name,
    this.cerId,
    this.cerDate,
    this.cerName,
         this.cerAuthority,
         this.startName,
         this.startAuthority,
         this.startDate,
         this.state,
         this.cause,
  });

  factory OperationModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String id = data['id'];
    final int date = data['date'];
    final String name = data['name'];
    final String cerId = data['cerId'];
    final int cerDate = data['cerDate'];
    final String cerName = data['cerName'];
    final String cerAuthority = data['cerAuthority'];
    final String startName = data['startName'];
    final String startAuthority = data['startAuthority'];
    final int startDate = data['startDate'];
    final bool state = data['state'];
    final String cause = data['cause'];

    return OperationModel(
      id: id,
      date: DateTime.fromMicrosecondsSinceEpoch(date),
      name: name,
      cerId: cerId,
      cerDate: DateTime.fromMicrosecondsSinceEpoch(cerDate),
      cerName: cerName,
      cerAuthority: cerAuthority,
      startName: startName,
      startAuthority: startAuthority,
      startDate: DateTime.fromMicrosecondsSinceEpoch(startDate),
        state: state,
        cause: cause,
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
      'cerAuthority': cerAuthority,
      'startName': startName,
      'startAuthority': startAuthority,
      'startDate': startDate.microsecondsSinceEpoch,
      'state': state,
      'cause': cause,
    };
  }
}
