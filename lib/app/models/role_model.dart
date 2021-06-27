class RoleModel {
  final String role;
  final String uid;

  RoleModel({this.role, this.uid});

  factory RoleModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String role = data['role'];
    final String uid = data['uid'];
    return RoleModel(
      role: role,
      uid: uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'uid': uid,
    };
  }
}
