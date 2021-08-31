class LoadTestModel {
  final String id;
  final DateTime date;
  final String name;
  final String cerId;
  final DateTime cerDate;
  final String cerName;
  final String cerAuthority;
  final String kind;
  final String load;
  final String measuredParam;
  final String measuredValue;

  LoadTestModel({
    this.id,
    this.date,
    this.name,
    this.cerId,
    this.cerDate,
    this.cerName,
    this.cerAuthority,
    this.kind,
    this.load,
    this.measuredParam,
    this.measuredValue,
  });

  factory LoadTestModel.fromMap(Map<String, dynamic> data) {
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
    final String kind = data['kind'];
    final String load = data['load'];
    final String measuredParam = data['measuredParam'];
    final String measuredValue = data['measuredValue'];

    return LoadTestModel(
      id: id,
      date: DateTime.fromMicrosecondsSinceEpoch(date),
      name: name,
      cerId: cerId,
      cerDate: DateTime.fromMicrosecondsSinceEpoch(cerDate),
      cerName: cerName,
      cerAuthority: cerAuthority,
      kind: kind,
      load: load,
      measuredParam: measuredParam,
      measuredValue: measuredValue,
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
      'kind': kind,
      'load': load,
      'measuredParam': measuredParam,
      'measuredValue': measuredValue,
    };
  }
}
