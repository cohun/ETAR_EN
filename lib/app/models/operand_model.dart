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
    List<Map<String, dynamic>> cer = [];
    data['certificates'].forEach(
      (value) =>
          cer.add({
            'description': value['description'],
            'nr': value['nr'],
            'date': value['date']
          }),
    );
    List<String> comp = [];
      data['companies'].forEach((val) {
        comp.add(val);
      });


    final String uid = data['uid'];

    return Operand(
      name: name,
      certificates: cer,
      companies: comp,
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
