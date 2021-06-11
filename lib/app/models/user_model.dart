class UserModel {
  final String name;
  final String company;
  final String role;
  String approvedRole;
  final String uid;
  String hyperCompany;
  String hyperRole;


  UserModel({
    this.name,
    this.company,
    this.role,
    this.approvedRole,
    this.uid,
    this.hyperCompany,
    this.hyperRole,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String company = data['company'];
    final String role = data['role'];
    String approvedRole = data['approvedRole'];
    final String uid = data['uid'];
    String hyperCompany = data['hyperCompany'];
    String hyperRole = data['hyperRole'];

    return UserModel(
        name: name,
        company: company,
        role: role,
        approvedRole: approvedRole,
        uid: uid,
        hyperCompany: hyperCompany,
        hyperRole: hyperRole
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'company': company,
      'role': role,
      'approvedRole': approvedRole,
      'uid': uid,
      'hyperCompany': hyperCompany,
      'hyperRole': hyperRole,
    };
  }
}