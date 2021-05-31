class Operand {
  final String name;
  final List<Map<String, dynamic>> certificates;
  final List<String> companies;
  final String uid;

  Operand({
    this.name,
    this.companies,
    this.certificates,
    this.uid,
  });

  factory Operand.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final List<Map<String, dynamic>> certificates = data['certificates'];
    final List<String> companies = data['companies'];
    final String uid = data['uid'];

    return Operand(
      name: name,
      certificates: certificates,
      companies: companies,
      uid: uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'certificates': certificates,
      'companies': companies,
      'uid': uid,
    };
  }
}
