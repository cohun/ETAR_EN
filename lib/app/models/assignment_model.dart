class Assignment {
  final String role;
  final String uid;

  Assignment({
    this.uid,
    this.role,
  });

  factory Assignment.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String role = data['role'];
    final String uid = data['uid'];

    return Assignment(
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
