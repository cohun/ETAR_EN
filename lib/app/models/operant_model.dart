class OperantModel {
  final String name;
  final List<String> certificates;
  final List<String> companies;
  final String role;
  final String uid;

  OperantModel({
    this.name,
    this.companies,
    this.certificates,
    this.role,
    this.uid,
  });

  factory OperantModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final List<String> certificates = data['certificates'];
    final List<String> companies = data['companies'];
    final String role = data['role'];
    final String uid = data['uid'];

    return OperantModel(
      name: name,
      certificates: certificates,
      companies: companies,
      role: role,
      uid: uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'certificates': certificates,
      'companies': companies,
      'role': role,
      'uid': uid,
    };
  }
}
