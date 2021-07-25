class PartsModel {
  final String id;
  final DateTime date;
  final String name;
  final String partName;
  final String partId;
  final String partSize;
  final String serviceName;

  PartsModel(
      {
        this.id,
        this.date,
        this.name,
        this.partName,
        this.partId,
        this.partSize,
        this.serviceName,
      });

  factory PartsModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String id = data['id'];
    final int date = data['date'];
    final String name = data['name'];
    final String partName = data['partName'];
    final String partId = data['partId'];
    final String partSize = data['partSize'];
    final String serviceName = data['serviceName'];

    return PartsModel(
      id: id,
      date: DateTime.fromMicrosecondsSinceEpoch(date),
      partName: partName,
      name: name,
      partId: partId,
      partSize: partSize,
      serviceName: serviceName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.microsecondsSinceEpoch,
      'name': name,
      'partName': partName,
      'partId': partId,
      'partSize': partSize,
      'serviceName': serviceName,
    };
  }
}
