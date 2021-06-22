class CounterModel {
  final String company;
  final String address;
  final num companyId;

  CounterModel({this.company, this.address, this.companyId});

  factory CounterModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String company = data['company'];
    final String address = data['address'];
    final num companyId = data['companyId'];
    return CounterModel(
      company: company,
      address: address,
      companyId: companyId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'address': address,
      'companyId': companyId,
    };
  }
}
